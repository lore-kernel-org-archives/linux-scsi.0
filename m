From: Hannes Reinecke <hare@suse.de>
Subject: Re: safety of retrying SYNCHRONIZE CACHE [was: Re: [PATCHSET block#for-2.6.36-post]
 block: replace barrier with sequenced flush]
Date: Wed, 01 Sep 2010 09:32:20 +0200
Message-ID: <4C7E0184.9030502@suse.de>
References: <4C6E3C1A.50205@ct.jp.nec.com> <4C72660A.7070009@kernel.org> <20100823141733.GA21158@redhat.com> <4C739DE9.5070803@ct.jp.nec.com> <4C73FA8F.5080800@kernel.org> <4C74CD95.1000208@ct.jp.nec.com> <20100825152831.GA8509@redhat.com> <4C7789BE.1060609@ct.jp.nec.com> <20100827134940.GA22504@redhat.com> <4C7B4C23.8020100@ct.jp.nec.com> <20100901005537.GA21466@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100901005537.GA21466@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com, Frederick.Knight@netapp.com
List-Id: linux-scsi@vger.kernel.org

Mike Snitzer wrote:
> Hi Kiyoshi,
>=20
> On Mon, Aug 30 2010 at  2:13am -0400,
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>=20
>>> That does seem like a valid concern.  But I'm not seeing why its un=
ique
>>> to SYNCHRONIZE CACHE.  Any IO that fails on the target side should =
be
>>> passed up once the error gets to DM.
>> See the Tejun's explanation again:
>>     http://marc.info/?l=3Dlinux-kernel&m=3D128267361813859&w=3D2
>> What I'm concerning is whether the same thing as Tejun explained
>> for ATA can happen on other types of devices.
>>
>>
>> Normal write command has data and no data loss happens on error.
>> So it can be retried cleanly, and if the result of the retry is
>> success, it's really success, no implicit data loss.
>>
>> Normal read command has a sector to read.  If the sector is broken,
>> all retries will fail and the error will be reported upwards.
>> So it can be retried cleanly as well.
>=20
> I reached out to Fred Knight on this, to get a more insight from a pu=
re
> SCSI SBC perspective, and he shared the following:
>=20
> ----- Forwarded message from "Knight, Frederick" <Frederick.Knight@ne=
tapp.com> -----
>=20
>> Date: Tue, 31 Aug 2010 13:24:15 -0400
>> From: "Knight, Frederick" <Frederick.Knight@netapp.com>
>> To: Mike Snitzer <snitzer@redhat.com>
>> Subject: RE: safety of retrying SYNCHRONIZE CACHE?
>>
>> There are requirements in SBC to maintain data integrity.  If you WR=
ITE
>> a block and READ that block, you must get the data you sent in the
>> WRITE.  This will be synchronized around the completion of the WRITE=
=2E
>> Before the WRITE completes, who knows what a READ will return.  Mayb=
e
>> all the old data, maybe all the new data, maybe some mix of old and =
new
>> data.  Once the WRITE ends successful, all READs of those LBAs (from=
 any
>> port) will always get the same data.
>>
>> As for errors, SBC describes how the deferred errors are reported (l=
ike
>> when a CACHE tries to flush but fails).  So if a write from cache to
>> media does have problems, the device would tell you via a CHECK
>> CONDITION (with the first byte of the sense data set to 71h or 73h. =
 SBC
>> clause 4.12 and 4.13 cover a lot of this information.  It is these e=
rror
>> codes that prevent silent loss of data.  And, in this case, when the
>> CHECK CONDITION is delivered, it will have nothing to do with the
>> command that was issued (the victim command).  If you look into the
>> sense data, you will see the deferred error flag, and all the additi=
onal
>> information fields will relate to the original I/O
>>
>> SYNCHRONIZE CACHE is not substantially different than a WRITE (it pu=
ts
>> data on the media).  So issuing it multiple times wouldn't be any
>> different than issuing multiple WRITES (it might put a temporary den=
t in
>> performance as everything flushes out to media).  If it or any other
>> commands fail with 71h/73h, then you have to dig down into the sense
>> data buffer to find out what happened.  For example, if you issue a
>> WRITE command, and it completes into write back cache but later (bef=
ore
>> being written to the media), some of the cache breaks and looses dat=
a,
>> then the device must signal a deferred error to tell the host, and c=
ause
>> a forced error on the LBA in question.
>>
>> Does that help?
>>
>>       Fred
> ----- End forwarded message -----
>=20
> Seems like verifying/improving the handling of CHECK CONDITION is a m=
ore
> pressing concern than silent data loss purely due to SYNCHRONIZE CACH=
E
> retries.  Without proper handling we could completely miss these
> deferred errors.
>=20
Yes.

> But how to effectively report such errors to upper layers is unclear =
to
> me given that a particular SCSI command can carry error information f=
or
> IO that was already acknowledged successful (e.g. to the FS).
>=20
> drivers/scsi/scsi_error.c's various calls to scsi_check_sense()
> illustrate Linux's current CHECK CONDITION handling.  I need to look
> closer at how deferred errors propagate to upper layers.  After an
> initial look it seems scsi_error.c does handle retrying commands wher=
e
> appropriate.
>=20
> I believe Hannes has concerns/insight here.
>=20

Quite. We _should_ be handling deferred errors correctly;
if you check drivers/scsi/scsi_lib.c:scsi_io_completion()
you'll find this:

	if (host_byte(result) =3D=3D DID_RESET) {
		/* Third party bus reset or reset for error recovery
		 * reasons.  Just retry the command and see what
		 * happens.
		 */
		action =3D ACTION_RETRY;
	} else if (sense_valid && !sense_deferred) {
                ...
	} else {
		description =3D "Unhandled error code";
		action =3D ACTION_FAIL;
	}

ie for deferred errors we're already aborting the command. Not sure
if I agree with this bit in drivers/scsi/scsi_lib.c:

static int scsi_check_sense(struct scsi_cmnd *scmd)
{
	struct scsi_device *sdev =3D scmd->device;
	struct scsi_sense_hdr sshdr;

	if (! scsi_command_normalize_sense(scmd, &sshdr))
		return FAILED;	/* no valid sense data */

	if (scsi_sense_is_deferred(&sshdr))
		return NEEDS_RETRY;

I doubt we can resolve the situation by retrying the command, which
will be the wrong command to retry anyway. I would rather
have those retry 'SUCCESS' and add another case in scsi_io_completion()
to notify us about the deferred error.

I'll be sending a patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
