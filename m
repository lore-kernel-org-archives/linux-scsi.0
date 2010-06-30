From: Audio Haven <audiohaven@gmail.com>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Wed, 30 Jun 2010 19:43:31 +0200
Message-ID: <AANLkTiljkvuYhitbrGR6o-qgDiv6ZM4dvlbL7wtH6xYp@mail.gmail.com>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	<1267786018.8894.43.camel@mulgrave.site>
	<6B62480106F2B34D8404CF2FDAA4D9EF71F65D5D21@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	<AANLkTimAdlkXIx7KW3URSx9EXYxZ1eaLlXoOg0fIQIr1@mail.gmail.com>
	<6B62480106F2B34D8404CF2FDAA4D9EF93F6390887@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44321 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab0F3Rnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 13:43:40 -0400
Received: by bwz1 with SMTP id 1so505311bwz.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2010 10:43:37 -0700 (PDT)
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF93F6390887@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Yugendranath R Singh - ERS, HCL Tech" <yugendranath.s@hcl.in>, "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.in>, "Mohan Kumar TG, ERS,HCLTech" <mohankumartg@hcl.in>

Hello Srinivas,

I recompiled your module with the suggested mdelay (100).
I still get lot's of mvs_I_T_nexus_reset errors:

drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[7]:rc=3D=
 0
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[3]:rc=3D=
 0
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=3D0x01 { Error }
ata14: error=3D0x04 { DriveStatusError }
drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[5]:rc=3D=
 0
ata16: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata16: status=3D0x01 { Error }
ata16: error=3D0x04 { DriveStatusError }
drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[5]:rc=3D=
 0
ata16: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata16: status=3D0x01 { Error }
ata16: error=3D0x04 { DriveStatusError }
drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[7]:rc=3D=
 0
ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata18: status=3D0x01 { Error }
ata18: error=3D0x04 { DriveStatusError }
drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[5]:rc=3D=
 0
ata16: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata16: status=3D0x01 { Error }
ata16: error=3D0x04 { DriveStatusError }

The above happened when trying to copy about 200GB of audio backups to
the array, which failed after 19GB. During the copy samba still times
out. When trying to delete the partially copied data directly on the
NAS, it takes ages and similar errors are seen:

[root@nas audio]# du -h -s
19G     .
[root@nas audio]# df -H .
=46ilesystem             Size   Used  Avail Use% Mounted on
/dev/mapper/jumbo-hdtv
                       6.1T   2.6T   3.5T  44% /mnt/movies
[root@nas audio]# rm -rf *

During the rm -rf, this occurs:

drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[5]:rc=3D=
 0
ata16: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata16: status=3D0x01 { Error }
ata16: error=3D0x04 { DriveStatusError }
drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[3]:rc=3D=
 0
ata14: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata14: status=3D0x01 { Error }
ata14: error=3D0x04 { DriveStatusError }

and it took ages to complete:

real    6m26.426s
user    0m0.008s
sys     0m0.254s

While this doesn't seem to break any data yet and the 8 drives are
never kicked from raid6, the timeouts and hickups are a serious
problem to data availability.

Best regards,

=46rederic Vanden Poel
aka Audio Haven

On Tue, Jun 29, 2010 at 2:16 PM, Srinivas Naga Venkatasatya
Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
> Hi,
>
> As I didn't have time to give the proper fix for this delay, I have m=
odified to mdelay (10) based on my testing.
>
> With the mdelay (100) every thing is working as expected?
>
> If so I have to modify the code in such a way that it has to reset al=
l the ports in parallel and then the settle time.
>
> -Srini
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Audio Haven
> Sent: Tuesday, June 29, 2010 5:17 PM
> To: Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech
> Cc: James Bottomley; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
>
> Hello Srinivas,
>
> I have tested this patch with a stock 2.6.32.7 kernel on a x86_64
> running Centos 5.5.
> I have another box with 8 1TB disks in a raid6 config: 6 drives are
> SAMSUNG HD103SI, 2 drives are Hitachi HDT721010SLA360.
>
> I frequently get the following behaviour:
>
> A large file IO suddenly becomes very slow (eg watching a HDTV file
> over samba), then the following is then reported:
>
> drivers/scsi/mvsas/mv_sas.c 1631:mvs_query_task:rc=3D 5
> drivers/scsi/mvsas/mv_sas.c 1967:Release slot [2] tag[2], task
> [ffff880035138700]:
> drivers/scsi/mvsas/mv_sas.c 1967:Release slot [0] tag[0], task
> [ffff88003b436000]:
> drivers/scsi/mvsas/mv_sas.c 1967:Release slot [3] tag[3], task
> [ffff88003b4361c0]:
> drivers/scsi/mvsas/mv_sas.c 1967:Release slot [4] tag[4], task
> [ffff88003b436380]:
> drivers/scsi/mvsas/mv_sas.c 1967:Release slot [5] tag[5], task
> [ffff88003b436540]:
> drivers/scsi/mvsas/mv_sas.c 1585:mvs_I_T_nexus_reset for device[7]:rc=
=3D 0
> ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata18: status=3D0x01 { Error }
> ata18: error=3D0x04 { DriveStatusError }
> ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata18: status=3D0x01 { Error }
> ata18: error=3D0x04 { DriveStatusError }
> ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata18: status=3D0x01 { Error }
> ata18: error=3D0x04 { DriveStatusError }
> ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata18: status=3D0x01 { Error }
> ata18: error=3D0x04 { DriveStatusError }
> ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata18: status=3D0x01 { Error }
> ata18: error=3D0x04 { DriveStatusError }
> ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata18: status=3D0x01 { Error }
> ata18: error=3D0x04 { DriveStatusError }
> ata18: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> ata18: status=3D0x01 { Error }
> ata18: error=3D0x04 { DriveStatusError }
>
> Now the disks are never kicked out of raid
>
> md2 : active raid6 sdl1[7] sde1[0] sdk1[6] sdj1[5] sdi1[4] sdh1[3]
> sdg1[2] sdf1[1]
> =A0 =A0 =A05860558848 blocks super 1.2 level 6, 1024k chunk, algorith=
m 2
> [8/8] [UUUUUUUU]
>
> but anything running on this disk is halted and causes time outs. In
> the past all these drives were connected to my motherboards SATA port=
s
> as JBOD and they never failed or timed out. When connected to the
> Supermicro AOC-SASLP-MV8 using your latest patch with the 10ms delay,
> they sometimes timeout, which is difficult to predict.
>
> Best regards,
>
> Frederic Vanden Poel
> aka Audio Haven
>
> On Mon, Mar 8, 2010 at 1:58 PM, Srinivas Naga Venkatasatya
> Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
>> James,
>>
>> Thanks a lot for reviewing this patch.
>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_update_phyinfo (mvi=
, phy_no, 0);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_type & PORT_=
TYPE_SAS) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_=
DISP->phy_reset (mvi, phy_no, 2);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdelay (1=
00);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> I agree with your analysis on the same. Mainly I have added this pie=
ce of code for Tape issues. Here I used 100 ms delay which is not requi=
red, so I have changed to 10ms i.e mdelay (10). I didn't face any issue=
s with devices after changing it to 10ms.
>> Please try to include this patch in RC tree. If required I will subm=
it one more patch for the same by considering your suggestion i.e reset=
 in parallel and then the settle time, but this requires a lot of testi=
ng to be done so it will take some time to submit the patch.
>>
>> NOTE: I have attached the patch (copied from below thread) which is =
having one change i.e mdelay (10).
>>
>> Thanks,
>> Srinivas.
>>
>> -----Original Message-----
>> From: James Bottomley [mailto:James.Bottomley@suse.de]
>> Sent: Friday, March 05, 2010 4:17 PM
>> To: Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech
>> Cc: linux-scsi@vger.kernel.org
>> Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
>>
>> On Tue, 2010-02-16 at 16:40 +0530, Srinivas Naga Venkatasatya
>> Pasagadugula - ERS, HCL Tech wrote:
>>> From: Srinivas <satyasrinivasp@hcl.in>
>>> Date: Mon, 15 Feb 2010
>>
>> So, I'll add it, it seems to work based on the reports.
>>
>>> Subject: [PATCH]: Fix for hot plug handling and IO issues.
>>> =A0 =A0 =A0 Added code for handling of hot-plugging drives and tape=
 issues.
>>
>> This is a bit terse for a change like this.
>>
>>> Signed-off-by: Srinivas <satyasrinivasp@hcl.in>
>>
>> This is the only bit that seems to have a serious technical problem:
>>
>>> @@ -2085,6 +2145,11 @@ void mvs_int_port(struct mvs_info *mvi, int =
phy_no, u32 events)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no, tmp);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_update_phyinfo(mvi,=
 phy_no, 0);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_type & PORT_=
TYPE_SAS) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_=
DISP->phy_reset(mvi, phy_no, 2);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdelay(10=
0);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> +
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_bytes_dmaed(mvi, ph=
y_no);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* whether driver is go=
ing to handle hot plug */
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_event & PH=
Y_PLUG_OUT) {
>>
>> It's doing a 100ms CPU spin for each port initialisation. =A0For an =
eight
>> port system, that's nearly a second, all of which is done with the
>> mvi->lock held. =A0In particular, this is done in the ISR on some sy=
stems,
>> so that's really going to add massive delays.
>>
>> It looks like this is just a bus settle time for the SAS ports, so
>> obviously they could all be reset in parallel and then the settle ti=
me
>> could be waited out (rather than doing each one in sequence), but
>> realistically even a single 100ms wait in an interrupt routine is to=
o
>> long ... the port probably has to be marked as in reset somehow to a=
void
>> this.
>>
>> Other than the above, there were a large number of checkpatch errors=
,
>> which I fixed:
>>
>> total: 58 errors, 19 warnings, 632 lines checked
>>
>> can you start with the patch below to carry these fixes forwards?
>>
>> Thanks,
>>
>> James
>>
>> ---
>>
>> diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64=
xx.c
>> index 10a5077..afc7f6f 100644
>> --- a/drivers/scsi/mvsas/mv_64xx.c
>> +++ b/drivers/scsi/mvsas/mv_64xx.c
>> @@ -132,9 +132,9 @@ static void mvs_64xx_phy_reset(struct mvs_info *=
mvi, u32 phy_id, int hard)
>> =A0 =A0 =A0 =A0tmp &=3D ~PHYEV_RDY_CH;
>> =A0 =A0 =A0 =A0mvs_write_port_irq_stat(mvi, phy_id, tmp);
>> =A0 =A0 =A0 =A0tmp =3D mvs_read_phy_ctl(mvi, phy_id);
>> - =A0 =A0 =A0 if (hard)
>> + =A0 =A0 =A0 if (hard =3D=3D 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tmp |=3D PHY_RST_HARD;
>> - =A0 =A0 =A0 else
>> + =A0 =A0 =A0 else if (hard =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tmp |=3D PHY_RST;
>> =A0 =A0 =A0 =A0mvs_write_phy_ctl(mvi, phy_id, tmp);
>> =A0 =A0 =A0 =A0if (hard) {
>> @@ -144,6 +144,26 @@ static void mvs_64xx_phy_reset(struct mvs_info =
*mvi, u32 phy_id, int hard)
>> =A0 =A0 =A0 =A0}
>> =A0}
>>
>> +void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 cl=
ear_all)
>> +{
>> + =A0 =A0 =A0 void __iomem *regs =3D mvi->regs;
>> + =A0 =A0 =A0 u32 tmp;
>> + =A0 =A0 =A0 if (clear_all) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D mr32(MVS_INT_STAT_SRS_0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "che=
ck SRS 0 %08X.\n", tmp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mw32(MVS_INT_STAT_SRS_=
0, tmp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D mr32(MVS_INT_STAT_SRS_0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tmp & =A0(1 << (reg_set % 32))) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_DEBUG "reg=
ister set 0x%x was stopped.\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reg_set=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mw32(MVS_INT_STAT_SRS_=
0, 1 << (reg_set % 32));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 }
>> +}
>> +
>> =A0static int __devinit mvs_64xx_chip_reset(struct mvs_info *mvi)
>> =A0{
>> =A0 =A0 =A0 =A0void __iomem *regs =3D mvi->regs;
>> @@ -761,6 +781,7 @@ const struct mvs_dispatch mvs_64xx_dispatch =3D =
{
>> =A0 =A0 =A0 =A0mvs_write_port_irq_mask,
>> =A0 =A0 =A0 =A0mvs_get_sas_addr,
>> =A0 =A0 =A0 =A0mvs_64xx_command_active,
>> + =A0 =A0 =A0 mvs_64xx_clear_srs_irq,
>> =A0 =A0 =A0 =A0mvs_64xx_issue_stop,
>> =A0 =A0 =A0 =A0mvs_start_delivery,
>> =A0 =A0 =A0 =A0mvs_rx_update,
>> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_in=
it.c
>> index cae6b2c..203ff93 100644
>> --- a/drivers/scsi/mvsas/mv_init.c
>> +++ b/drivers/scsi/mvsas/mv_init.c
>> @@ -37,6 +37,7 @@ static const struct mvs_chip_info mvs_chips[] =3D =
{
>> =A0};
>>
>> =A0#define SOC_SAS_NUM 2
>> +#define SG_MX 64
>>
>> =A0static struct scsi_host_template mvs_sht =3D {
>> =A0 =A0 =A0 =A0.module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D THIS_MODU=
LE,
>> @@ -53,10 +54,10 @@ static struct scsi_host_template mvs_sht =3D {
>> =A0 =A0 =A0 =A0.can_queue =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 1,
>> =A0 =A0 =A0 =A0.cmd_per_lun =A0 =A0 =A0 =A0 =A0 =A0=3D 1,
>> =A0 =A0 =A0 =A0.this_id =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D -1,
>> - =A0 =A0 =A0 .sg_tablesize =A0 =A0 =A0 =A0 =A0 =3D SG_ALL,
>> + =A0 =A0 =A0 .sg_tablesize =A0 =A0 =A0 =A0 =A0 =3D SG_MX,
>> =A0 =A0 =A0 =A0.max_sectors =A0 =A0 =A0 =A0 =A0 =A0=3D SCSI_DEFAULT_=
MAX_SECTORS,
>> =A0 =A0 =A0 =A0.use_clustering =A0 =A0 =A0 =A0 =3D ENABLE_CLUSTERING=
,
>> - =A0 =A0 =A0 .eh_device_reset_handler =A0 =A0 =A0 =A0=3D sas_eh_dev=
ice_reset_handler,
>> + =A0 =A0 =A0 .eh_device_reset_handler =3D sas_eh_device_reset_handl=
er,
>> =A0 =A0 =A0 =A0.eh_bus_reset_handler =A0 =3D sas_eh_bus_reset_handle=
r,
>> =A0 =A0 =A0 =A0.slave_alloc =A0 =A0 =A0 =A0 =A0 =A0=3D mvs_slave_all=
oc,
>> =A0 =A0 =A0 =A0.target_destroy =A0 =A0 =A0 =A0 =3D sas_target_destro=
y,
>> @@ -65,19 +66,17 @@ static struct scsi_host_template mvs_sht =3D {
>>
>> =A0static struct sas_domain_function_template mvs_transport_ops =3D =
{
>> =A0 =A0 =A0 =A0.lldd_dev_found =A0 =A0 =A0 =A0 =3D mvs_dev_found,
>> - =A0 =A0 =A0 .lldd_dev_gone =A0=3D mvs_dev_gone,
>> -
>> + =A0 =A0 =A0 .lldd_dev_gone =A0 =A0 =A0 =A0 =A0=3D mvs_dev_gone,
>> =A0 =A0 =A0 =A0.lldd_execute_task =A0 =A0 =A0=3D mvs_queue_command,
>> =A0 =A0 =A0 =A0.lldd_control_phy =A0 =A0 =A0 =3D mvs_phy_control,
>>
>> =A0 =A0 =A0 =A0.lldd_abort_task =A0 =A0 =A0 =A0=3D mvs_abort_task,
>> =A0 =A0 =A0 =A0.lldd_abort_task_set =A0 =A0=3D mvs_abort_task_set,
>> =A0 =A0 =A0 =A0.lldd_clear_aca =A0 =A0 =A0 =A0 =3D mvs_clear_aca,
>> - =A0 =A0 =A0 .lldd_clear_task_set =A0 =A0=3D mvs_clear_task_set,
>> + =A0 =A0 =A0 .lldd_clear_task_set =A0 =A0=3D mvs_clear_task_set,
>> =A0 =A0 =A0 =A0.lldd_I_T_nexus_reset =A0 =3D mvs_I_T_nexus_reset,
>> =A0 =A0 =A0 =A0.lldd_lu_reset =A0 =A0 =A0 =A0 =A0=3D mvs_lu_reset,
>> =A0 =A0 =A0 =A0.lldd_query_task =A0 =A0 =A0 =A0=3D mvs_query_task,
>> -
>> =A0 =A0 =A0 =A0.lldd_port_formed =A0 =A0 =A0 =3D mvs_port_formed,
>> =A0 =A0 =A0 =A0.lldd_port_deformed =A0 =A0 =3D mvs_port_deformed,
>>
>> @@ -213,7 +212,11 @@ static irqreturn_t mvs_interrupt(int irq, void =
*opaque)
>>
>> =A0static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_=
Host *shost)
>> =A0{
>> - =A0 =A0 =A0 int i, slot_nr;
>> + =A0 =A0 =A0 int i =3D 0, j =3D 0, slot_nr;
>> + =A0 =A0 =A0 unsigned long buf_size;
>> + =A0 =A0void *buf;
>> + =A0 =A0dma_addr_t buf_dma;
>> + =A0 =A0struct mvs_slot_info *slot =3D 0;
>>
>> =A0 =A0 =A0 =A0if (mvi->flags & MVF_FLAG_SOC)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot_nr =3D MVS_SOC_SLOTS;
>> @@ -232,6 +235,7 @@ static int __devinit mvs_alloc(struct mvs_info *=
mvi, struct Scsi_Host *shost)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->devices[i].dev_type =3D NO_DEVIC=
E;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->devices[i].device_id =3D i;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->devices[i].dev_status =3D MVS_DE=
V_NORMAL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 init_timer(&mvi->devices[i].timer);
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0/*
>> @@ -437,6 +441,7 @@ static int __devinit mvs_prep_sas_ha_init(struct=
 Scsi_Host *shost,
>>
>> =A0 =A0 =A0 =A0sha->sas_phy =3D arr_phy;
>> =A0 =A0 =A0 =A0sha->sas_port =3D arr_port;
>> + =A0 =A0 =A0 sha->core.shost =3D shost;
>>
>> =A0 =A0 =A0 =A0sha->lldd_ha =3D kzalloc(sizeof(struct mvs_prv_info),=
 GFP_KERNEL);
>> =A0 =A0 =A0 =A0if (!sha->lldd_ha)
>> @@ -574,6 +579,10 @@ static int __devinit mvs_pci_init(struct pci_de=
v *pdev,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nhost++;
>> =A0 =A0 =A0 =A0} while (nhost < chip->n_host);
>> +#ifdef MVS_USE_TASKLET
>> + =A0 =A0 =A0 tasklet_init(&mv_tasklet, mvs_tasklet,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long)SHOST_TO_SAS=
_HA(shost));
>> +#endif
>>
>> =A0 =A0 =A0 =A0mvs_post_sas_ha_init(shost, chip);
>>
>> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas=
=2Ec
>> index 0d21386..4be7010 100644
>> --- a/drivers/scsi/mvsas/mv_sas.c
>> +++ b/drivers/scsi/mvsas/mv_sas.c
>> @@ -259,8 +259,6 @@ static inline void mvs_free_reg_set(struct mvs_i=
nfo *mvi,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_printk("device has been free.\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>> =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 if (dev->runing_req !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> =A0 =A0 =A0 =A0if (dev->taskfileset =3D=3D MVS_ID_NOT_MAPPED)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>> =A0 =A0 =A0 =A0MVS_CHIP_DISP->free_reg_set(mvi, &dev->taskfileset);
>> @@ -597,7 +595,7 @@ static int mvs_task_prep_ata(struct mvs_info *mv=
i,
>> =A0 =A0 =A0 =A0struct mvs_slot_info *slot;
>> =A0 =A0 =A0 =A0void *buf_prd;
>> =A0 =A0 =A0 =A0u32 tag =3D tei->tag, hdr_tag;
>> - =A0 =A0 =A0 u32 flags, del_q;
>> + =A0 =A0 =A0 u32 flags, del_q, phy_mask;
>> =A0 =A0 =A0 =A0void *buf_tmp;
>> =A0 =A0 =A0 =A0u8 *buf_cmd, *buf_oaf;
>> =A0 =A0 =A0 =A0dma_addr_t buf_tmp_dma;
>> @@ -762,8 +760,6 @@ static int mvs_task_prep_ssp(struct mvs_info *mv=
i,
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0if (is_tmf)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D (MCH_SSP_FR_TASK << MCH_SS=
P_FR_TYPE_SHIFT);
>> - =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D (MCH_SSP_FR_CMD << MCH_SSP_=
=46R_TYPE_SHIFT);
>> =A0 =A0 =A0 =A0hdr->flags =3D cpu_to_le32(flags | (tei->n_elem << MC=
H_PRD_LEN_SHIFT));
>> =A0 =A0 =A0 =A0hdr->tags =3D cpu_to_le32(tag);
>> =A0 =A0 =A0 =A0hdr->data_len =3D cpu_to_le32(task->total_xfer_len);
>> @@ -878,14 +874,15 @@ static int mvs_task_exec(struct sas_task *task=
, const int num, gfp_t gfp_flags,
>> =A0 =A0 =A0 =A0struct mvs_slot_info *slot;
>> =A0 =A0 =A0 =A0u32 tag =3D 0xdeadbeef, rc, n_elem =3D 0;
>> =A0 =A0 =A0 =A0u32 n =3D num, pass =3D 0;
>> - =A0 =A0 =A0 unsigned long flags =3D 0;
>> + =A0 =A0 =A0 unsigned long flags =3D 0, =A0flags_libsas =3D 0;
>>
>> =A0 =A0 =A0 =A0if (!dev->port) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct task_status_struct *tsm =3D &t=
->task_status;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tsm->resp =3D SAS_TASK_UNDELIVERED;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tsm->stat =3D SAS_PHY_DOWN;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_done(t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev->dev_type !=3D SATA_DEV)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->task_done(t);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>> =A0 =A0 =A0 =A0}
>>
>> @@ -910,12 +907,24 @@ static int mvs_task_exec(struct sas_task *task=
, const int num, gfp_t gfp_flags,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tei.port =3D &mvi->po=
rt[dev->port->id];
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!tei.port->port_attached) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tei.port && !tei.port->port_attach=
ed) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sas_protocol_ata(=
t->task_proto)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dp=
rintk("port %d does not"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0"attached device.\n", dev->port->id);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D=
 SAS_PHY_DOWN;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto o=
ut_done;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 task_status_struct *ts =3D &t->task_status;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ts->st=
at =3D SAS_PROTO_RESPONSE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ts->st=
at =3D SAS_PHY_DOWN;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_u=
nlock_irqrestore(dev->sata_dev.ap->lock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags_libsas);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_u=
nlock_irqrestore(&mvi->lock, flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->tas=
k_done(t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_l=
ock_irqsave(&mvi->lock, flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_l=
ock_irqsave(dev->sata_dev.ap->lock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags_libsas);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (n =
> 1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 t =3D list_entry(t->list.next,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sas_task, list);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 contin=
ue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struc=
t task_status_struct *ts =3D &t->task_status;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ts->r=
esp =3D SAS_TASK_UNDELIVERED;
>> @@ -973,8 +982,8 @@ static int mvs_task_exec(struct sas_task *task, =
const int num, gfp_t gfp_flags,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_printk(KERN_ERR, =
mvi->dev,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "unkno=
wn sas_task proto: 0x%x\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t->tas=
k_proto);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"unknown sas_task proto: 0x%x\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
t->task_proto);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EINVAL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> @@ -993,11 +1002,15 @@ static int mvs_task_exec(struct sas_task *tas=
k, const int num, gfp_t gfp_flags,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&t->task_state_lock);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_hba_memory_dump(mvi, tag, t->task=
_proto);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->runing_req++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->running_req++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0++pass;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->tx_prod =3D (mvi->tx_prod + 1) &=
 (MVS_CHIP_SLOT_SZ - 1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (n > 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t =3D list_entry(t->l=
ist.next, struct sas_task, list);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(pass))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->start_d=
elivery(mvi, (mvi->tx_prod - 1) &
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (MVS_CHIP_SLOT_SZ - 1));
>> +
>> =A0 =A0 =A0 =A0} while (--n);
>> =A0 =A0 =A0 =A0rc =3D 0;
>> =A0 =A0 =A0 =A0goto out_done;
>> @@ -1012,10 +1025,6 @@ err_out:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dma_unmap_sg(mvi->dev=
, t->scatter, n_elem,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 t->data_dir);
>> =A0out_done:
>> - =A0 =A0 =A0 if (likely(pass)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->start_delivery(mvi,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mvi->tx_prod - 1) & (=
MVS_CHIP_SLOT_SZ - 1));
>> - =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, flags);
>> =A0 =A0 =A0 =A0return rc;
>> =A0}
>> @@ -1187,7 +1196,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, =
int i, int get_st)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MVS_C=
HIP_DISP->phy_reset(mvi, i, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto =
out_done;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if =
(phy->phy_type & PORT_TYPE_SAS
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } =A0 =A0 =A0 else if (phy->phy_type &=
 PORT_TYPE_SAS
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|| phy->att_dev_info =
& PORT_SSP_INIT_MASK) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy->phy_attached =3D=
 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy->identify.device_=
type =3D
>> @@ -1256,7 +1265,20 @@ static void mvs_port_notify_formed(struct asd=
_sas_phy *sas_phy, int lock)
>>
>> =A0static void mvs_port_notify_deformed(struct asd_sas_phy *sas_phy,=
 int lock)
>> =A0{
>> - =A0 =A0 =A0 /*Nothing*/
>> + =A0 =A0 =A0 struct domain_device *dev;
>> + =A0 =A0 =A0 struct mvs_phy *phy =3D sas_phy->lldd_phy;
>> + =A0 =A0 =A0 struct mvs_info *mvi =3D phy->mvi;
>> + =A0 =A0 =A0 struct asd_sas_port *port =3D sas_phy->port;
>> + =A0 =A0 =A0 int phy_no =3D 0;
>> +
>> + =A0 =A0 =A0 while (phy !=3D &mvi->phy[phy_no]) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy_no >=3D MVS_MAX_PHYS)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> + =A0 =A0 =A0 }
>> + =A0 =A0 =A0 list_for_each_entry(dev, &port->dev_list, dev_list_nod=
e)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_do_release_task(phy->mvi, phy_no, =
NULL);
>> +
>> =A0}
>>
>>
>> @@ -1316,6 +1338,7 @@ int mvs_dev_found_notify(struct domain_device =
*dev, int lock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto found_out;
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0dev->lldd_dev =3D mvi_device;
>> + =A0 =A0 =A0 mvi_device->dev_status =3D MVS_DEV_NORMAL;
>> =A0 =A0 =A0 =A0mvi_device->dev_type =3D dev->dev_type;
>> =A0 =A0 =A0 =A0mvi_device->mvi_info =3D mvi;
>> =A0 =A0 =A0 =A0if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_typ=
e)) {
>> @@ -1351,18 +1374,18 @@ int mvs_dev_found(struct domain_device *dev)
>> =A0 =A0 =A0 =A0return mvs_dev_found_notify(dev, 1);
>> =A0}
>>
>> -void mvs_dev_gone_notify(struct domain_device *dev, int lock)
>> +void mvs_dev_gone_notify(struct domain_device *dev)
>> =A0{
>> =A0 =A0 =A0 =A0unsigned long flags =3D 0;
>> =A0 =A0 =A0 =A0struct mvs_device *mvi_dev =3D dev->lldd_dev;
>> =A0 =A0 =A0 =A0struct mvs_info *mvi =3D mvi_dev->mvi_info;
>>
>> - =A0 =A0 =A0 if (lock)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&mvi->lock, flags);
>> + =A0 =A0 =A0 spin_lock_irqsave(&mvi->lock, flags);
>>
>> =A0 =A0 =A0 =A0if (mvi_dev) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dprintk("found dev[%d:%x] is gone.=
\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi_dev->device_id, m=
vi_dev->dev_type);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, dev);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_reg_set(mvi, mvi_dev);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_dev(mvi_dev);
>> =A0 =A0 =A0 =A0} else {
>> @@ -1370,14 +1393,13 @@ void mvs_dev_gone_notify(struct domain_devic=
e *dev, int lock)
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0dev->lldd_dev =3D NULL;
>>
>> - =A0 =A0 =A0 if (lock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, fl=
ags);
>> =A0}
>>
>>
>> =A0void mvs_dev_gone(struct domain_device *dev)
>> =A0{
>> - =A0 =A0 =A0 mvs_dev_gone_notify(dev, 1);
>> + =A0 =A0 =A0 mvs_dev_gone_notify(dev);
>> =A0}
>>
>> =A0static =A0struct sas_task *mvs_alloc_task(void)
>> @@ -1540,7 +1562,7 @@ int mvs_lu_reset(struct domain_device *dev, u8=
 *lun)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num =3D mvs_find_dev_phyno(dev, phyno=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&mvi->lock, flags);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < num; i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, =
phyno[i], dev);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, =
dev);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, fl=
ags);
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0/* If failed, fall-through I_T_Nexus reset */
>> @@ -1552,8 +1574,8 @@ int mvs_lu_reset(struct domain_device *dev, u8=
 *lun)
>> =A0int mvs_I_T_nexus_reset(struct domain_device *dev)
>> =A0{
>> =A0 =A0 =A0 =A0unsigned long flags;
>> - =A0 =A0 =A0 int i, phyno[WIDE_PORT_MAX_PHY], num , rc =3D TMF_RESP=
_FUNC_FAILED;
>> - =A0 =A0 =A0 struct mvs_device * mvi_dev =3D (struct mvs_device *)d=
ev->lldd_dev;
>> + =A0 =A0 =A0 int rc =3D TMF_RESP_FUNC_FAILED;
>> + =A0 =A0struct mvs_device * mvi_dev =3D (struct mvs_device *)dev->l=
ldd_dev;
>> =A0 =A0 =A0 =A0struct mvs_info *mvi =3D mvi_dev->mvi_info;
>>
>> =A0 =A0 =A0 =A0if (mvi_dev->dev_status !=3D MVS_DEV_EH)
>> @@ -1563,10 +1585,8 @@ int mvs_I_T_nexus_reset(struct domain_device =
*dev)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, mvi_dev->device_id, rc);
>>
>> =A0 =A0 =A0 =A0/* housekeeper */
>> - =A0 =A0 =A0 num =3D mvs_find_dev_phyno(dev, phyno);
>> =A0 =A0 =A0 =A0spin_lock_irqsave(&mvi->lock, flags);
>> - =A0 =A0 =A0 for (i =3D 0; i < num; i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, phyno[i], dev);
>> + =A0 =A0 =A0 mvs_release_task(mvi, dev);
>> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, flags);
>>
>> =A0 =A0 =A0 =A0return rc;
>> @@ -1603,6 +1623,9 @@ int mvs_query_task(struct sas_task *task)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case TMF_RESP_FUNC_FAILED:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case TMF_RESP_FUNC_COMPLETE:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D TMF_RESP_FUNC_C=
OMPLETE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0mv_printk("%s:rc=3D %d\n", __func__, rc);
>> @@ -1621,8 +1644,11 @@ int mvs_abort_task(struct sas_task *task)
>> =A0 =A0 =A0 =A0unsigned long flags;
>> =A0 =A0 =A0 =A0u32 tag;
>>
>> - =A0 =A0 =A0 if (mvi->exp_req)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi->exp_req--;
>> + =A0 =A0 =A0 if (!mvi_dev) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_printk("%s:%d TMF_RESP_FUNC_FAILED\=
n", __func__, __LINE__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D TMF_RESP_FUNC_FAILED;
>> + =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0spin_lock_irqsave(&task->task_state_lock, flags);
>> =A0 =A0 =A0 =A0if (task->task_state_flags & SAS_TASK_STATE_DONE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&task->task_st=
ate_lock, flags);
>> @@ -1630,6 +1656,7 @@ int mvs_abort_task(struct sas_task *task)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&task->task_state_lock, flags)=
;
>> + =A0 =A0 =A0 mvi_dev->dev_status =3D MVS_DEV_EH;
>> =A0 =A0 =A0 =A0if (task->lldd_task && task->task_proto & SAS_PROTOCO=
L_SSP) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct scsi_cmnd * cmnd =3D (struct s=
csi_cmnd *)task->uldd_task;
>>
>> @@ -1654,12 +1681,31 @@ int mvs_abort_task(struct sas_task *task)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (task->lldd_task) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot =
=3D task->lldd_task;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot_=
no =3D (u32) (slot - mvi->slot_info);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_l=
ock_irqsave(&mvi->lock, flags);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_s=
lot_complete(mvi, slot_no, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_u=
nlock_irqrestore(&mvi->lock, flags);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> +
>> =A0 =A0 =A0 =A0} else if (task->task_proto & SAS_PROTOCOL_SATA ||
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0task->task_proto & SAS_PROTOCOL_STP) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* to do free register_set */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (SATA_DEV =3D=3D dev->dev_type) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mvs_slot_info *=
slot =3D task->lldd_task;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct task_status_str=
uct *tstat;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 slot_idx =3D (u32)=
(slot - mvi->slot_info);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat =3D &task->task_=
status;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk(KERN_DEBUG =
"mv_abort_task() mvi=3D%p task=3D%p "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"slot=3D%p slot_idx=3Dx%x\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
mvi, task, slot, slot_idx);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat->stat =3D SAS_AB=
ORTED_TASK;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvi_dev && mvi_dev=
->running_req)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_de=
v->running_req--;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sas_protocol_ata(t=
ask->task_proto))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_fr=
ee_reg_set(mvi, mvi_dev);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_slot_task_free(mvi=
, task, slot, slot_idx);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0} else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* SMP */
>>
>> @@ -1717,8 +1763,13 @@ static int mvs_sata_done(struct mvs_info *mvi=
, struct sas_task *task,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 SATA_RECEIVED_D2H_FIS(mvi_dev->taskfiles=
et),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct dev_to_host_fis));
>> =A0 =A0 =A0 =A0tstat->buf_valid_size =3D sizeof(*resp);
>> - =A0 =A0 =A0 if (unlikely(err))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_PROTO_RESPONSE;
>> + =A0 =A0 =A0 if (unlikely(err)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(err & CMD_ISS_STPD))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_OPEN_REJE=
CT;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_PROTO_RES=
PONSE;
>> + =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0return stat;
>> =A0}
>>
>> @@ -1728,6 +1779,7 @@ static int mvs_slot_err(struct mvs_info *mvi, =
struct sas_task *task,
>> =A0 =A0 =A0 =A0struct mvs_slot_info *slot =3D &mvi->slot_info[slot_i=
dx];
>> =A0 =A0 =A0 =A0int stat;
>> =A0 =A0 =A0 =A0u32 err_dw0 =3D le32_to_cpu(*(u32 *) (slot->response)=
);
>> + =A0 =A0 =A0 u32 err_dw1 =3D le32_to_cpu(*((u32 *)slot->response+1)=
);
>> =A0 =A0 =A0 =A0u32 tfs =3D 0;
>> =A0 =A0 =A0 =A0enum mvs_port_type type =3D PORT_TYPE_SAS;
>>
>> @@ -1753,9 +1805,7 @@ static int mvs_slot_err(struct mvs_info *mvi, =
struct sas_task *task,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_printk("find reser=
ved error, why?\n");
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0task->ata_task.use_ncq =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat =3D SAS_PROTO_RESPONSE;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_sata_done(mvi, task, slot_idx, 1);
>> -
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_sata_done(mvi, task, slot_idx, err=
_dw0);
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> =A0 =A0 =A0 =A0default:
>> @@ -1772,18 +1822,20 @@ int mvs_slot_complete(struct mvs_info *mvi, =
u32 rx_desc, u32 flags)
>> =A0 =A0 =A0 =A0struct sas_task *task =3D slot->task;
>> =A0 =A0 =A0 =A0struct mvs_device *mvi_dev =3D NULL;
>> =A0 =A0 =A0 =A0struct task_status_struct *tstat;
>> + =A0 =A0 =A0 struct domain_device *dev;
>> + =A0 =A0 =A0 u32 aborted;
>>
>> - =A0 =A0 =A0 bool aborted;
>> =A0 =A0 =A0 =A0void *to;
>> =A0 =A0 =A0 =A0enum exec_status sts;
>>
>> =A0 =A0 =A0 =A0if (mvi->exp_req)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvi->exp_req--;
>> - =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task))
>> + =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task || !task->dev))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
>>
>> =A0 =A0 =A0 =A0tstat =3D &task->task_status;
>> - =A0 =A0 =A0 mvi_dev =3D task->dev->lldd_dev;
>> + =A0 =A0 =A0 dev =3D task->dev;
>> + =A0 =A0 =A0 mvi_dev =3D dev->lldd_dev;
>>
>> =A0 =A0 =A0 =A0mvs_hba_cq_dump(mvi);
>>
>> @@ -1800,8 +1852,8 @@ int mvs_slot_complete(struct mvs_info *mvi, u3=
2 rx_desc, u32 flags)
>>
>> =A0 =A0 =A0 =A0if (unlikely(aborted)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D SAS_ABORTED_TASK;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvi_dev)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->runing_req--;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mvi_dev && mvi_dev->running_req)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->running_req--=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sas_protocol_ata(task->task_proto=
))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_reg_set(mvi,=
 mvi_dev);
>>
>> @@ -1809,24 +1861,17 @@ int mvs_slot_complete(struct mvs_info *mvi, =
u32 rx_desc, u32 flags)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
>> =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 if (unlikely(!mvi_dev || !slot->port->port_attached ||=
 flags)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk("port has not device.\n");
>> + =A0 =A0 =A0 if (unlikely(!mvi_dev || flags)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!mvi_dev)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk("port has n=
ot device.\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D SAS_PHY_DOWN;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>> =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 if (unlikely((rx_desc & RXQ_ERR) || (*(u64 *) slot->re=
sponse))) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dprintk("Find device[%016llx] RX=
Q_ERR %X,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err info:%016llx\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SAS_ADDR(task->dev->sas_addr),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rx_desc, (u64)(*(u64 *) slot->respo=
nse));
>> - =A0 =A0 =A0 }
>> - =A0 =A0 =A0 */
>> -
>> =A0 =A0 =A0 =A0/* error info record present */
>> =A0 =A0 =A0 =A0if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->r=
esponse))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D mvs_slot_err(mvi, tas=
k, slot_idx);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat->resp =3D SAS_TASK_COMPLETE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>> =A0 =A0 =A0 =A0}
>>
>> @@ -1868,11 +1913,16 @@ int mvs_slot_complete(struct mvs_info *mvi, =
u32 rx_desc, u32 flags)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tstat->stat =3D SAM_CHECK_COND;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> =A0 =A0 =A0 =A0}
>> + =A0 =A0 =A0 if (!slot->port->port_attached) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_dprintk("port %d has removed.\n", s=
lot->port->sas_port.id);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstat->stat =3D SAS_PHY_DOWN;
>> + =A0 =A0 =A0 }
>> +
>>
>> =A0out:
>> - =A0 =A0 =A0 if (mvi_dev) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->runing_req--;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sas_protocol_ata(task->task_proto)=
)
>> + =A0 =A0 =A0 if (mvi_dev && mvi_dev->running_req) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvi_dev->running_req--;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sas_protocol_ata(task->task_proto)=
 && !mvi_dev->running_req)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_free_reg_set(mvi,=
 mvi_dev);
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0mvs_slot_task_free(mvi, task, slot, slot_idx);
>> @@ -1888,10 +1938,10 @@ out:
>> =A0 =A0 =A0 =A0return sts;
>> =A0}
>>
>> -void mvs_release_task(struct mvs_info *mvi,
>> +void mvs_do_release_task(struct mvs_info *mvi,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int phy_no, struct domain_device *dev=
)
>> =A0{
>> - =A0 =A0 =A0 int i =3D 0; u32 slot_idx;
>> + =A0 =A0 =A0 u32 slot_idx;
>> =A0 =A0 =A0 =A0struct mvs_phy *phy;
>> =A0 =A0 =A0 =A0struct mvs_port *port;
>> =A0 =A0 =A0 =A0struct mvs_slot_info *slot, *slot2;
>> @@ -1900,6 +1950,10 @@ void mvs_release_task(struct mvs_info *mvi,
>> =A0 =A0 =A0 =A0port =3D phy->port;
>> =A0 =A0 =A0 =A0if (!port)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>> + =A0 =A0 =A0 /* clean cmpl queue in case request is already finishe=
d */
>> + =A0 =A0 =A0 mvs_int_rx(mvi, false);
>> +
>> +
>>
>> =A0 =A0 =A0 =A0list_for_each_entry_safe(slot, slot2, &port->list, en=
try) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sas_task *task;
>> @@ -1911,18 +1965,22 @@ void mvs_release_task(struct mvs_info *mvi,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_printk("Release slot [%x] tag[%x],=
 task [%p]:\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0slot_idx, slot->slot_=
tag, task);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (task->task_proto & SAS_PROTOCOL_SS=
P) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_printk("attached wi=
th SSP task CDB[");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < 16; =
i++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_pri=
ntk(" %02x", task->ssp_task.cdb[i]);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mv_printk(" ]\n");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->command_active(mvi, slo=
t_idx);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_slot_complete(mvi, slot_idx, 1);
>> =A0 =A0 =A0 =A0}
>> =A0}
>>
>> +void mvs_release_task(struct mvs_info *mvi,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct domain_device *dev)
>> +{
>> + =A0 =A0 =A0 int i, phyno[WIDE_PORT_MAX_PHY], num;
>> + =A0 =A0 =A0 /* housekeeper */
>> + =A0 =A0 =A0 num =3D mvs_find_dev_phyno(dev, phyno);
>> + =A0 =A0 =A0 for (i =3D 0; i < num; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_do_release_task(mvi, phyno[i], dev=
);
>> +}
>> +
>> =A0static void mvs_phy_disconnected(struct mvs_phy *phy)
>> =A0{
>> =A0 =A0 =A0 =A0phy->phy_attached =3D 0;
>> @@ -2029,16 +2087,18 @@ void mvs_int_port(struct mvs_info *mvi, int =
phy_no, u32 events)
>> =A0 =A0 =A0 =A0* we need check the interrupt status which belongs to=
 per port.
>> =A0 =A0 =A0 =A0*/
>>
>> - =A0 =A0 =A0 if (phy->irq_status & PHYEV_DCDR_ERR)
>> + =A0 =A0 =A0 if (phy->irq_status & PHYEV_DCDR_ERR) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mv_dprintk("port %d STP decoding erro=
r.\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no+mvi->id*mvi->chip->n_phy);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 phy_no + mvi->id*mvi->chip->n_phy);
>> + =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0if (phy->irq_status & PHYEV_POOF) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!(phy->phy_event & PHY_PLUG_OUT))=
 {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int dev_sata =3D phy-=
>phy_type & PORT_TYPE_SATA;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int ready;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, =
phy_no, NULL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_do_release_task(mv=
i, phy_no, NULL);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy->phy_event |=3D P=
HY_PLUG_OUT;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CHIP_DISP->clear_s=
rs_irq(mvi, 0, 1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_handle_event(mvi,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(void=
 *)(unsigned long)phy_no,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PHY_P=
LUG_EVENT);
>> @@ -2085,6 +2145,11 @@ void mvs_int_port(struct mvs_info *mvi, int p=
hy_no, u32 events)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phy_no, tmp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_update_phyinfo(mv=
i, phy_no, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phy->phy_type & PO=
RT_TYPE_SAS) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MVS_CH=
IP_DISP->phy_reset(mvi, phy_no, 2);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mdelay=
(100);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mvs_bytes_dmaed(mvi, =
phy_no);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* whether driver is =
going to handle hot plug */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (phy->phy_event & =
PHY_PLUG_OUT) {
>> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas=
=2Eh
>> index aa2270a..85b79c7 100644
>> --- a/drivers/scsi/mvsas/mv_sas.h
>> +++ b/drivers/scsi/mvsas/mv_sas.h
>> @@ -38,6 +38,7 @@
>> =A0#include <linux/irq.h>
>> =A0#include <linux/vmalloc.h>
>> =A0#include <scsi/libsas.h>
>> +#include <scsi/scsi.h>
>> =A0#include <scsi/scsi_tcq.h>
>> =A0#include <scsi/sas_ata.h>
>> =A0#include <linux/version.h>
>> @@ -48,7 +49,7 @@
>> =A0#define _MV_DUMP =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
>> =A0#define MVS_ID_NOT_MAPPED =A0 =A0 =A00x7f
>> =A0/* #define DISABLE_HOTPLUG_DMA_FIX */
>> -#define MAX_EXP_RUNNING_REQ =A0 =A02
>> +// #define MAX_EXP_RUNNING_REQ 2
>> =A0#define WIDE_PORT_MAX_PHY =A0 =A0 =A0 =A0 =A0 =A0 =A04
>> =A0#define =A0 =A0 =A0 =A0MV_DISABLE_NCQ =A00
>> =A0#define mv_printk(fmt, arg ...) =A0 =A0 =A0 =A0\
>> @@ -128,6 +129,7 @@ struct mvs_dispatch {
>>
>> =A0 =A0 =A0 =A0void (*get_sas_addr)(void *buf, u32 buflen);
>> =A0 =A0 =A0 =A0void (*command_active)(struct mvs_info *mvi, u32 slot=
_idx);
>> + =A0 =A0 =A0 void (*clear_srs_irq)(struct mvs_info *mvi, u8 reg_set=
, u8 clear_all);
>> =A0 =A0 =A0 =A0void (*issue_stop)(struct mvs_info *mvi, enum mvs_por=
t_type type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u32 t=
fs);
>> =A0 =A0 =A0 =A0void (*start_delivery)(struct mvs_info *mvi, u32 tx);
>> @@ -235,9 +237,10 @@ struct mvs_device {
>> =A0 =A0 =A0 =A0enum sas_dev_type dev_type;
>> =A0 =A0 =A0 =A0struct mvs_info *mvi_info;
>> =A0 =A0 =A0 =A0struct domain_device *sas_device;
>> + =A0 =A0 =A0 struct timer_list timer;
>> =A0 =A0 =A0 =A0u32 attached_phy;
>> =A0 =A0 =A0 =A0u32 device_id;
>> - =A0 =A0 =A0 u32 runing_req;
>> + =A0 =A0 =A0 u32 running_req;
>> =A0 =A0 =A0 =A0u8 taskfileset;
>> =A0 =A0 =A0 =A0u8 dev_status;
>> =A0 =A0 =A0 =A0u16 reserved;
>> @@ -396,7 +399,9 @@ int mvs_lu_reset(struct domain_device *dev, u8 *=
lun);
>> =A0int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flag=
s);
>> =A0int mvs_I_T_nexus_reset(struct domain_device *dev);
>> =A0int mvs_query_task(struct sas_task *task);
>> -void mvs_release_task(struct mvs_info *mvi, int phy_no,
>> +void mvs_release_task(struct mvs_info *mvi,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct domain_device *=
dev);
>> +void mvs_do_release_task(struct mvs_info *mvi, int phy_no,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct domain_device =
*dev);
>> =A0void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
>> =A0void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
>>
>>
>>
>> DISCLAIMER:
>> --------------------------------------------------------------------=
---------------------------------------------------
>>
>> The contents of this e-mail and any attachment(s) are confidential a=
nd intended for the named recipient(s) only.
>> It shall not attach any liability on the originator or HCL or its af=
filiates. Any views or opinions presented in
>> this email are solely those of the author and may not necessarily re=
flect the opinions of HCL or its affiliates.
>> Any form of reproduction, dissemination, copying, disclosure, modifi=
cation, distribution and / or publication of
>> this message without the prior written consent of the author of this=
 e-mail is strictly prohibited. If you have
>> received this email in error please delete it and notify the sender =
immediately. Before opening any mail and
>> attachments please check them for viruses and defect.
>>
>> --------------------------------------------------------------------=
---------------------------------------------------
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
