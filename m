From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V3 11/24] aacraid: Added support for periodic wellness
 sync
Date: Mon, 30 Jan 2017 20:07:46 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A7B8A6D59@avsrvexchmbx2.microsemi.net>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-12-RaghavaAditya.Renukunta@microsemi.com>
 <20170130102701.GH3603@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0086.outbound.protection.outlook.com ([104.47.40.86]:14019
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754348AbdA3UH5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 15:07:57 -0500
In-Reply-To: <20170130102701.GH3603@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>



> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 30, 2017 2:27 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V3 11/24] aacraid: Added support for periodic wellnes=
s
> sync
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Fri, Jan 27, 2017 at 11:28:40AM -0800, Raghava Aditya Renukunta wrote:
> > This patch adds a new functions that periodically sync the time of host
> > to the adapter. In addition also informs the adapter that the driver is
> > alive and kicking. Only applicable to the HBA1000 and SMARTIOC2000.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> > Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> >
> > ---
> > Changes in  V2:
> > None
> >
> > Changes in  V3:
> > None
> >
> >  drivers/scsi/aacraid/aacraid.h |   3 +
> >  drivers/scsi/aacraid/commsup.c | 176
> +++++++++++++++++++++++++++++++++--------
> >  2 files changed, 148 insertions(+), 31 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacr=
aid.h
> > index b54c1bf..05884e6 100644
> > --- a/drivers/scsi/aacraid/aacraid.h
> > +++ b/drivers/scsi/aacraid/aacraid.h
> > @@ -88,6 +88,9 @@ enum {
> >  #define AAC_MAX_NATIVE_SIZE          2048
> >
> >  #define CISS_REPORT_PHYSICAL_LUNS    0xc3
> > +#define WRITE_HOST_WELLNESS          0xa5
> > +#define BMIC_IN                      0x26
> > +#define BMIC_OUT                     0x27
> >
> >  struct aac_ciss_phys_luns_resp {
> >       u8      list_length[4];         /* LUN list length (N-7, big endi=
an) */
> > diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> > index 346c1c0..0c009f1 100644
> > --- a/drivers/scsi/aacraid/commsup.c
> > +++ b/drivers/scsi/aacraid/commsup.c
> > @@ -43,6 +43,7 @@
> >  #include <linux/kthread.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/semaphore.h>
> > +#include <linux/bcd.h>
> >  #include <scsi/scsi.h>
> >  #include <scsi/scsi_host.h>
> >  #include <scsi/scsi_device.h>
> > @@ -1946,6 +1947,143 @@ static void aac_process_events(struct aac_dev
> *dev)
> >                       flags);
> >  }
> >
> > +static int aac_send_wellness_command(struct aac_dev *dev, char
> *wellness_str,
> > +                                                     u32 datasize)
> > +{
> > +     struct aac_srb *srbcmd;
> > +     struct sgmap64 *sg64;
> > +     dma_addr_t addr;
> > +     char *dma_buf;
> > +     struct fib *fibptr;
> > +     int ret =3D -ENOMEM;
> > +
> > +     fibptr =3D aac_fib_alloc(dev);
> > +     if (fibptr) {
> > +             aac_fib_init(fibptr);
> > +
> > +             dma_buf =3D pci_alloc_consistent(dev->pdev, datasize, &ad=
dr);
> > +             if (dma_buf !=3D NULL) {
>=20
> if (!dma_buf)
>         return -ENOMEM;
Yes , let me make the changes.
>=20
> It makes the code flow more obvious and saves you a level of indent.
>=20
> > +                     u32 vbus, vid;
> > +
> > +                     vbus =3D (u32)le16_to_cpu(
> > +                             dev->supplement_adapter_info.VirtDeviceBu=
s);
> > +                     vid =3D (u32)le16_to_cpu(
> > +                             dev->supplement_adapter_info.VirtDeviceTa=
rget);
> > +
> > +                     srbcmd =3D (struct aac_srb *)fib_data(fibptr);
> > +
> > +                     srbcmd->function =3D cpu_to_le32(SRBF_ExecuteScsi=
);
> > +                     srbcmd->channel =3D cpu_to_le32(vbus);
> > +                     srbcmd->id =3D cpu_to_le32(vid);
> > +                     srbcmd->lun =3D 0;
> > +                     srbcmd->flags =3D cpu_to_le32(SRB_DataOut);
> > +                     srbcmd->timeout =3D cpu_to_le32(10);
> > +                     srbcmd->retry_limit =3D 0;
> > +                     srbcmd->cdb_size =3D cpu_to_le32(12);
> > +                     srbcmd->count =3D cpu_to_le32(datasize);
> > +
> > +                     memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
> > +                     srbcmd->cdb[0] =3D BMIC_OUT;
> > +                     srbcmd->cdb[6] =3D WRITE_HOST_WELLNESS;
> > +                     memcpy(dma_buf, (char *)wellness_str, datasize);
> > +
> > +                     sg64 =3D (struct sgmap64 *)&srbcmd->sg;
> > +                     sg64->count =3D cpu_to_le32(1);
> > +                     sg64->sg[0].addr[1] =3D
> > +                             cpu_to_le32((u32)(((addr) >> 16) >> 16));
> > +                     sg64->sg[0].addr[0] =3D
> > +                             cpu_to_le32((u32)(addr & 0xffffffff));
> > +                     sg64->sg[0].count =3D cpu_to_le32(datasize);
> > +
> > +                     ret =3D aac_fib_send(ScsiPortCommand64, fibptr,
> > +                             sizeof(struct aac_srb), FsaNormal,
> > +                             1, 1, NULL, NULL);
> > +
> > +                     pci_free_consistent(dev->pdev, datasize,
> > +                                             (void *)dma_buf, addr);
> > +     }
> > +
> > +             /*
> > +              * Do not set XferState to zero unless
> > +              * receives a response from F/W
> > +              */
> > +             if (ret >=3D 0)
> > +                     aac_fib_complete(fibptr);
> > +
> > +             /*
> > +              * FIB should be freed only after
> > +              * getting the response from the F/W
> > +              */
> > +             if (ret !=3D -ERESTARTSYS)
> > +                     aac_fib_free(fibptr);
> > +     }
>=20
> Not sure if it's my mailclient, but indentation looks a bit odd here.
I agree  I will check out  what's going on here.
> > +
> > +     return ret;
> > +}
> > +
> > +int aac_send_hosttime(struct aac_dev *dev, struct timeval *now)
> > +{
> > +     int ret =3D -ENOMEM;
> > +     struct fib *fibptr;
> > +
> > +     /*
> > +      *  This whole block needs to be rewritten with helpers
> > +      *  Changing tabs to a single space should not be allowed!!
> > +      */
> > +
> > +     if (dev->sa_firmware) {
> > +             struct tm cur_tm;
> > +             char wellness_str[] =3D "<HW>TD\010\0\0\0\0\0\0\0\0\0DW\0=
\0ZZ";
> > +             u32 datasize =3D sizeof(wellness_str);
> > +             unsigned long local_time;
> > +
> > +             local_time =3D (u32)(now->tv_sec - (sys_tz.tz_minuteswest=
 * 60));
> > +             time_to_tm(local_time, 0, &cur_tm);
> > +             cur_tm.tm_mon +=3D 1;
> > +             cur_tm.tm_year +=3D 1900;
> > +             wellness_str[8] =3D bin2bcd(cur_tm.tm_hour);
> > +             wellness_str[9] =3D bin2bcd(cur_tm.tm_min);
> > +             wellness_str[10] =3D bin2bcd(cur_tm.tm_sec);
> > +             wellness_str[12] =3D bin2bcd(cur_tm.tm_mon);
> > +             wellness_str[13] =3D bin2bcd(cur_tm.tm_mday);
> > +             wellness_str[14] =3D bin2bcd(cur_tm.tm_year / 100);
> > +             wellness_str[15] =3D bin2bcd(cur_tm.tm_year % 100);
> > +
> > +             ret =3D aac_send_wellness_command(dev, wellness_str, data=
size);
> > +
> > +             return ret;
> > +     }
> > +
> > +     fibptr =3D aac_fib_alloc(dev);
> > +     if (fibptr) {
>=20
> Same here.
Here as well.=20

> > +             __le32 *info;
> > +
> > +             aac_fib_init(fibptr);
> > +             info =3D (__le32 *)fib_data(fibptr);
> > +             *info =3D cpu_to_le32(now->tv_sec);
> > +             ret =3D aac_fib_send(
> > +                     SendHostTime, fibptr,
> > +                     sizeof(*info), FsaNormal,
> > +                     1, 1, NULL, NULL);
> > +
> > +             /*
> > +              * Do not set XferState to zero unless
> > +              * receives a response from F/W
> > +              */
> > +             if (ret >=3D 0)
> > +                     aac_fib_complete(fibptr);
> > +
> > +             /*
> > +              * FIB should be freed only after
> > +              * getting the response from the F/W
> > +              */
> > +             if (ret !=3D -ERESTARTSYS)
> > +                     aac_fib_free(fibptr);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> >  /**
> >   *   aac_command_thread      -       command processing thread
> >   *   @dev: Adapter to monitor
> > @@ -2001,7 +2139,7 @@ int aac_command_thread(void *data)
> >
> >                       /* Don't even try to talk to adapter if its sick =
*/
> >                       ret =3D aac_check_health(dev);
> > -                     if (!ret && !dev->queues)
> > +                     if (!dev->queues)
> >                               break;
> >                       next_check_jiffies =3D jiffies
> >                                          + ((long)(unsigned)check_inter=
val)
> > @@ -2014,36 +2152,12 @@ int aac_command_thread(void *data)
> >                               difference =3D (((1000000 - now.tv_usec) =
* HZ)
> >                                 + 500000) / 1000000;
> >                       else if (ret =3D=3D 0) {
> > -                             struct fib *fibptr;
> > -
> > -                             if ((fibptr =3D aac_fib_alloc(dev))) {
> > -                                     int status;
> > -                                     __le32 *info;
> > -
> > -                                     aac_fib_init(fibptr);
> > -
> > -                                     info =3D (__le32 *) fib_data(fibp=
tr);
> > -                                     if (now.tv_usec > 500000)
> > -                                             ++now.tv_sec;
> > -
> > -                                     *info =3D cpu_to_le32(now.tv_sec)=
;
> > -
> > -                                     status =3D aac_fib_send(SendHostT=
ime,
> > -                                             fibptr,
> > -                                             sizeof(*info),
> > -                                             FsaNormal,
> > -                                             1, 1,
> > -                                             NULL,
> > -                                             NULL);
> > -                                     /* Do not set XferState to zero u=
nless
> > -                                      * receives a response from F/W *=
/
> > -                                     if (status >=3D 0)
> > -                                             aac_fib_complete(fibptr);
> > -                                     /* FIB should be freed only after
> > -                                      * getting the response from the =
F/W */
> > -                                     if (status !=3D -ERESTARTSYS)
> > -                                             aac_fib_free(fibptr);
> > -                             }
> > +
> > +                             if (now.tv_usec > 500000)
> > +                                     ++now.tv_sec;
> > +
> > +                             ret =3D aac_send_hosttime(dev, &now);
> > +
> >                               difference =3D (long)(unsigned)update_int=
erval*HZ;
> >                       } else {
> >                               /* retry shortly */

Thank you,
Raghava Aditya

> > --
> > 2.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
