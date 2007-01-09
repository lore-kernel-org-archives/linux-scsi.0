From: "Adam Zimman" <azimman@vmware.com>
Subject: RE: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Tue, 9 Jan 2007 10:14:00 -0800
Message-ID: <65B5F504434AD3469DC12E5564E3794D01EAB81D@PA-EXCH02.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:3309 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbXAISS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 13:18:28 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manon Goo <manon@manon.de>, Michael Reed <mdr@sgi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, David Berghoff <david@dg-i.net>, Petr Vandrovec <petr@vmware.com>, Vicky Xu <vgxu@vmware.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

Adding VMware engineering...=20

-----Original Message-----
=46rom: Manon Goo [mailto:manon@manon.de]=20
Sent: Tuesday, January 09, 2007 9:49 AM
To: Michael Reed; Moore, Eric; David Berghoff
Cc: James Bottomley; Adam Zimman; linux-scsi@vger.kernel.org; Shirron,
Stephen
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retri=
es

Hmm .... why don't w make the whole thing configurable (david implement=
ed
this for us)


+/*
+ *  cmd line parameters
+ */
+static int mpt_mpi_busy;
+module_param(mpt_mpi_busy, int, 0);
+MODULE_PARM_DESC(mpt_mpi_busy, " MPT MPI busy workaround for VMWare ES=
X=20
(default=3D0)");
+
=20
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D
*/

 typedef struct _BIG_SENSE_BUF {
@@ -704,10 +711,13 @@
                        sc->resid=3D0;
                case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:        /* 0x00=
40 */
                case MPI_IOCSTATUS_SUCCESS:                     /* 0x00=
00 */
-                       if (scsi_status =3D=3D MPI_SCSI_STATUS_BUSY)
+                       if ((scsi_status =3D=3D MPI_SCSI_STATUS_BUSY) &=
&=20
!mpt_mpi_busy)
                                sc->result =3D (DID_BUS_BUSY << 16) |=20
scsi_status;
-                       else
+                       else {
+                                if (mpt_mpi_busy)
+                                        printk(KERN_INFO "MPT MPI ESX =
busy=20
hack enabled ... waiting\n");
                                sc->result =3D (DID_OK << 16) | scsi_st=
atus;
+                        }
                        if (scsi_state =3D=3D 0) {
                                ;
                        } else if (scsi_state &=20
MPI_SCSI_STATE_AUTOSENSE_VALID) {



The prink(KERN... could be set if mpt_mpi_busy =3D=3D 2 to make debuggi=
ng of=20
the situation optional

Manon

--On 9. Januar 2007 10:17:17 -0600 Michael Reed <mdr@sgi.com> wrote:

>
>
> Moore, Eric wrote:
>> On  Monday, January 08, 2007 3:25 PM, James Bottomley wrote:
>>
>>> Right, I sort of suspected something like this.  BUSY/QUEUE_FULL
>>> handling was a bit iffy in 2.4; but it was sorted out in the 2003/4
>>> timeframe.  Nowadays, I think you want to translate the
>>> MPI_SCSI_STATUS_BUSY directly to SAM_STAT_BUSY (i.e. just remove th=
e
>>> special casing if).
>
> Christoph put in code to limit a command's lifetime to prevent infini=
te
> loops in the case of QUEUE_FULL and BUSY.  (See scsi_softirq_done()
> for implementation.)
>
> DID_OK / COMMAND_COMPLETE / BUSY results in a ADD_TO_MLQUEUE for a re=
try,
> same as QUEUE_FULL.  I don't infinite retries, just a whole lot of th=
em.
> See scsi_decide_disposition().
>
> Mike
>
>>>
>>
>> I think your'e on the same page with the folks from VMware,
>> where the've asked us to go back to our old driver code.
>> Meaning we kill the check for "MPI_SCSI_STATUS_BUSY", instead the sa=
m
>> status
>> is sent back "as is" without changing the DID_OK to DID_BUS_BUSY, et=
c.
>>
>> My problem with that is whether is breaks the Fibre Channel Folks.
>> Will FC failover solution work properly if we go back to the old cod=
e?
>> I add Stephen Shirron and Mike Reed.
>> I don't know.   Here is an explanation why that fix was needed back
>> about a year ago:
>>
>>
>> "When a target device responds with BUSY status, the MPT driver was
>> sending DID_OK to the
>> SCSI mid layer, which caused the IO to be retried indefinitely betwe=
en
>> the mid layer and the
>> driver.  By changing the driver return status to DID_BUS_BUSY, the
>> target BUSY status can
>> now flow through the mid layer to an upper layer Failover driver, wh=
ich
>> will manage the I/O timeout."
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>



Manon Goo
Dembach Goo Informatik GmbH & Co KG
Rathenauplatz 9
D-50674 K=F6ln
Tel: +49 221 801483 0
Mobil: +49 177 8091974
=46ax: +49 221 801483 20
Email: manon@dg-i.net

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
