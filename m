From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: I/O error during controller reboot
Date: Tue, 14 Apr 2009 19:15:36 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410F4D02D@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "'sekharan@us.ibm.com'" <sekharan@us.ibm.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James,

I am having issue with scsi_io_completion routine. During device discover=
y, READ CAPACITY is failing with 02/04/01. It has been retried 5 times(wi=
th NEED_RETRY) but when retry gets exhausted ,scsi_io_completion simply e=
nds the request without doing any delay retry as mentioned by you in belo=
w mail. =20

scsi_io_completion routine checks for deferred sense and if not found, it=
 sets error with -EIO, which eventually ends the request and doesnot allo=
w for any more retries. I am seeing deffered error being checked only for=
 REQ_TYPE_BLOCK_PC command type. Does it meant that command with cmd_type=
 REQ_TYPE_BLOCK_PC having current error sense should not be retried in sc=
si_io_completion? If yes, then would it be better to retry in rdac device=
 handler in that case.=20


On Tues, 2009-03-10 at 15:47, James Bottomley wrote:
> > +		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x01)
> > +			/* LUN Not Ready - Logical Unit Not=20
> Ready and is in
> > +			 * the process of becoming ready
> > +			 * Just retry.
> > +			 */
> > +			return ADD_TO_MLQUEUE;
> > +		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x04)
> > +			/* LUN Not Ready - Format In Progress
> > +			 *
> > +			 * Just retry.
> > +			 */
> > +			return ADD_TO_MLQUEUE;
> > +		if (sense_hdr->asc =3D=3D 0x04  && sense_hdr->ascq =3D=3D 0x07)
> > +			/* LUN Not Ready - Storage controller=20
> cannot respond
> > +			 * immediately to a PRIN or PROUT command.
> > +			 * Just retry.
> > +			 */
> > +			return ADD_TO_MLQUEUE;
>=20
> For all of these ... along with a few other not ready types,=20
> we already
> do a delayed retry at the mid-layer (in scsi_io_completion).  Is there
> some problem that causes this to need to be handled here as well?

Thanks,
Vijay
