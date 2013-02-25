From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] scsi: use 64-bit LUNs
Date: Mon, 25 Feb 2013 16:52:51 +0100
Message-ID: <512B88D3.1030801@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <1361261883-41467-3-git-send-email-hare@suse.de> <512B8454.4050806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758721Ab3BYPwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2013 10:52:53 -0500
In-Reply-To: <512B8454.4050806@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

On 02/25/2013 04:33 PM, Steffen Maier wrote:
> Hi Hannes,
>
> I like the idea and most of the patch set, so I only have a few quest=
ions left
 > and some review comments below.
>
> Just curious: Do you also plan to adapt systemd/udev, especially path=
_id for
 > fc transport with its open coded copy of int_to_scsilun()?
>
Yes.

> Since I don't see zfcp touched in this patch set, assuming this set w=
ill get
 > merged, I plan to adapt a few spots in zfcp that might not work=20
with 64 bit
 > luns out of the box although most of it already works with 64 bit=20
luns inside.
>
Ah. Yes, this might be a good idea. I've already got a patch from=20
QLogic regarding qla4xxx, so maybe we should be adding them as=20
separate patches on top of the original patchset.

> Speaking of opaque handling of scsi luns: Lately I noticed that some =
sg3_utils
 > tools decode the lun format and only report parts of the entire=20
64 bit fcp lun,
 > e.g. sg_scan or "sg_luns -d". I don't have enough historical scsi=20
experience to
 > know why that is, maybe because of some SPI background. By itself=20
this is not a
 > problem, however, rescan-scsi-bus.sh makes use of those scsi lun=20
parts and then
 > fails when matching those with the full scsi lun exposed by the=20
midlayer to user
 > space. E.g. with flat space addresses of IBM DS8000 this does not=20
seem to work:
>
> # sg_luns -v -s2 -d /dev/sg2 | head
>      report luns cdb: a0 00 02 00 00 00 00 00 20 00 00 00
>      report luns: requested 8192 bytes but got 4112 bytes
> Lun list length =3D 4104 which imples 513 lun entries
> Report luns [select_report=3D2]:
>      c101000000000000
>        REPORT LUNS well known logical unit
>      4020400000000000
>        Flat space addressing: lun=3D32
>      4020400100000000
>        Flat space addressing: lun=3D32
>      4020400200000000
>        Flat space addressing: lun=3D32
>                                   ^^<=3D=3D=3D 0x20 of the lun's 1st =
short
>
> Did I overlook something or are rescan-scsi-bus.sh and maybe other to=
ols really
 > broken with some "modern" scsi targets?
>
Should've been fixed by now.
There was a bug in rescan-scsi-bus.sh which indeed tried to decode=20
LUNs, but that has been fixed.

> On 02/19/2013 09:18 AM, Hannes Reinecke wrote:
>> The SCSI standard uses a 64-bit value for LUNs, and large arrays
>> employing large LUN numbers become more and more common.
>> So move the linux SCSI stack to use 64-bit LUN numbers.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>
>>    drivers/scsi/scsi_proc.c                |    2 +-
>
>>    drivers/scsi/scsi_sysfs.c               |   14 ++++----
>>    drivers/scsi/scsi_transport_fc.c        |    4 +-
>>    drivers/scsi/scsi_transport_iscsi.c     |    4 +-
>>    drivers/scsi/scsi_transport_sas.c       |    2 +-
>>    drivers/scsi/sg.c                       |    4 +-
>
>>    include/scsi/scsi.h                     |    2 +-
>>    include/scsi/scsi_device.h              |   22 ++++++------
>>    include/scsi/scsi_transport.h           |    2 +-
>>    50 files changed, 239 insertions(+), 247 deletions(-)
>
>> --- a/drivers/scsi/scsi_proc.c
>> +++ b/drivers/scsi/scsi_proc.c
>> @@ -196,7 +196,7 @@ static int proc_print_scsidevice(struct device *=
dev, void *data)
>>
>>    	sdev =3D to_scsi_device(dev);
>>    	seq_printf(s,
>> -		"Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
>> +		"Host: scsi%d Channel: %02d Id: %02d Lun: %02llu\n  Vendor: ",
>>    		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
>>    	for (i =3D 0; i < 8; i++) {
>>    		if (sdev->vendor[i] >=3D 0x20)
>
> Is it intentional that you did not adapt scsi_add_single_device(),
 > scsi_remove_single_device(), proc_scsi_write() to cope with 64=20
bit luns?
> (in the admittedly old and probably somewhat deprecated procfs interf=
ace;
 > but then again, proc_print_scsidevice can output 64 bit luns now)
>
I deliberately did _not_ touch procfs (apart from the necessary=20
bits). Precisely because it's being marked as deprecated.

>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 931a7d9..6e98f05 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -80,7 +80,7 @@ const char *scsi_host_state_name(enum scsi_host_st=
ate state)
>>    	return name;
>>    }
>>
>> -static int check_set(unsigned int *val, char *src)
>> +static int check_set(unsigned long long *val, char *src)
>>    {
>>    	char *last;
>>
>> @@ -90,7 +90,7 @@ static int check_set(unsigned int *val, char *src)
>>    		/*
>>    		 * Doesn't check for int overflow
>>    		 */
>> -		*val =3D simple_strtoul(src, &last, 0);
>> +		*val =3D simple_strtoull(src, &last, 0);
>>    		if (*last !=3D '\0')
>>    			return 1;
>>    	}
>> @@ -99,11 +99,11 @@ static int check_set(unsigned int *val, char *sr=
c)
>>
>>    static int scsi_scan(struct Scsi_Host *shost, const char *str)
>>    {
>> -	char s1[15], s2[15], s3[15], junk;
>> -	unsigned int channel, id, lun;
>> +	char s1[15], s2[15], s3[17], junk;
>
> Since we use automatic base detection with the 3rd argument of simple=
_strtoull()
 > being 0 in check_set() above, I think the user is free to specify=20
the lun to scan
 > for in decimal/octal/hex base for s3.
 >
Yes, we could (in principle).
However, it's not quite clear to me what the user is supposed to=20
enter here in these cases.
Original output from REPORT LUNS?
Output from scsilun_to_int?
So we would need to come up with a proper naming scheme to identify=20
these kind of things.
However, this should be done with another patch as it's a different=20
story. scsi_debug has a similar issue, and will need to be updated=20
for this, too.

> With 64 bits, couldn't this need a maximum of 20 decimal digits (plus=
 '\0' termination)
 > which is more than 16? I think this is a legitimate use case as=20
long as the scsi lun is
 > represented in decimal in sysfs so users might just have it from=20
the h:c:t:l device name there.
> While I don't think anyone would specify the lun in octal, it could e=
ven need 22 digits.
> [Maximum number of digits is ceil(ln(2**64-1)/ln(base)) if I'm not mi=
staken.]
>
Yeah, you're right. I need to increase this to the correct size.

>> +	unsigned long long channel, id, lun;
>>    	int res;
>>
>> -	res =3D sscanf(str, "%10s %10s %10s %c", s1, s2, s3, &junk);
>> +	res =3D sscanf(str, "%10s %10s %16s %c", s1, s2, s3, &junk);
>
> ditto
>
>>    	if (res !=3D 3)
>>    		return -EINVAL;
>>    	if (check_set(&channel, s1))
>
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tr=
ansport_fc.c
>> index e894ca7..091210f 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -2093,7 +2093,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
>>     * on the rport.
>>     */
>>    static void
>> -fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, ui=
nt lun)
>> +fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, ui=
nt64_t lun)
>>    {
>>    	struct fc_rport *rport;
>>    	unsigned long flags;
>> @@ -2125,7 +2125,7 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint=
 channel, uint id, uint lun)
>>     * object as the parent.
>>     */
>>    static int
>> -fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint l=
un)
>> +fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint64=
_t lun)
>
> Is it OK, that the maximum lun 2**64-1 overlaps with SCAN_WILD_CARD=3D=
=3D~0 from scsi.h?
>
It's the same as today, isn't it?

>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index be2c9a6..271d23d 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>
> I guess we cannot adapt sg_ioctl SG_GET_SCSI_ID that easily without b=
reaking
 > the user space interface. But how does a user of this interface=20
know that there
 > are 64 bit luns in the kernel but the ioctl cannot handle the new=20
kernel functionality
 > (and may be affected by aliasing)?
>
Hmm. I thought that SG_GET_SCSI_ID is largely deprecated by now;=20
every user should be converted to use sysfs.
But yeah, you're right. I'll be looking into that.

Thanks for your input.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
