From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: Re: [RESEND][PATCH 2/8][SCSI] mpt2sas : Fix for issue Missing delay
 not getting set during system bootup
Date: Tue, 26 Feb 2013 16:59:59 +0530
Message-ID: <20130226112959.GA1556@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, sreekanth.reddy@lsi.com
List-Id: linux-scsi@vger.kernel.org

> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Sunday, February 24, 2013 2:26 PM
> To: Reddy, Sreekanth
> Cc: Nandigama, Nagalakshmi; linux-scsi@vger.kernel.org; Prakash, Sathya;
> stable@vger.kernel.org
> Subject: Re: [RESEND][PATCH 2/8][SCSI] mpt2sas : Fix for issue Missing delay
> not getting set during system bootup
> 
> On Sat, 2013-02-02 at 00:54 +0530, Sreekanth Reddy wrote:
> > Missing delay is not getting set properly. The reason is it is not defined in
> the same file from where it is being invoked.
> >
> > The fix is to move the missing delay module parameter from
> mpt2sas_base.c to mpt2sas_scsh.c.
> >
> > Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> > Cc: stable@vger.kernel.org
> > ---
> >
> > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > index 0bb2b30..ce89b14 100644
> > --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > @@ -80,10 +80,6 @@ static int msix_disable = -1;
> > module_param(msix_disable, int, 0);  MODULE_PARM_DESC(msix_disable,
> "
> > disable msix routed interrupts (default=0)");
> >
> > -static int missing_delay[2] = {-1, -1};
> > -module_param_array(missing_delay, int, NULL, 0);
> > -MODULE_PARM_DESC(missing_delay, " device missing delay , io missing
> > delay");
> > -
> >  static int mpt2sas_fwfault_debug;
> >  MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of
> firmware fault "
> >  	"and halt firmware - (default=0)");
> > @@ -2183,7 +2179,7 @@ _base_display_ioc_capabilities(struct
> > MPT2SAS_ADAPTER *ioc)  }
> >
> >  /**
> > - * _base_update_missing_delay - change the missing delay timers
> > + * mpt2sas_base_update_missing_delay - change the missing delay
> > + timers
> >   * @ioc: per adapter object
> >   * @device_missing_delay: amount of time till device is reported missing
> >   * @io_missing_delay: interval IO is returned when there is a missing
> > device @@ -2194,8 +2190,8 @@ _base_display_ioc_capabilities(struct
> MPT2SAS_ADAPTER *ioc)
> >   * delay, as well as the io missing delay. This should be called at driver
> >   * load time.
> >   */
> > -static void
> > -_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
> > +void
> > +mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
> >  	u16 device_missing_delay, u8 io_missing_delay)  {
> >  	u16 dmd, dmd_new, dmd_orignal;
> > @@ -4391,10 +4387,6 @@ mpt2sas_base_attach(struct
> MPT2SAS_ADAPTER *ioc)
> >  	if (r)
> >  		goto out_free_resources;
> >
> > -	if (missing_delay[0] != -1 && missing_delay[1] != -1)
> > -		_base_update_missing_delay(ioc, missing_delay[0],
> > -		    missing_delay[1]);
> > -
> >  	return 0;
> >
> >   out_free_resources:
> > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h
> > b/drivers/scsi/mpt2sas/mpt2sas_base.h
> > index b46024c..ee7a030 100644
> > --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> > @@ -1054,6 +1054,9 @@ void mpt2sas_base_validate_event_type(struct
> > MPT2SAS_ADAPTER *ioc, u32 *event_ty
> >
> >  void mpt2sas_halt_firmware(struct MPT2SAS_ADAPTER *ioc);
> >
> > +void mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER
> *ioc,
> > +	u16 device_missing_delay, u8 io_missing_delay);
> > +
> >  int mpt2sas_port_enable(struct MPT2SAS_ADAPTER *ioc);
> >
> >  /* scsih shared API */
> > diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > index af4e6c4..ab89b2d 100644
> > --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> > @@ -101,6 +101,10 @@ static ushort max_sectors = 0xFFFF;
> > module_param(max_sectors, ushort, 0);
> MODULE_PARM_DESC(max_sectors,
> > "max sectors, range 64 to 32767  default=32767");
> >
> > +static int missing_delay[2] = {-1, -1};
> > +module_param_array(missing_delay, int, NULL, 0);
> > +MODULE_PARM_DESC(missing_delay, " device missing delay , io missing
> > +delay");
> > +
> >  /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
> > #define MPT2SAS_MAX_LUN (16895)  static int max_lun =
> MPT2SAS_MAX_LUN;
> > @@ -7303,7 +7307,9 @@ _firmware_event_work(struct work_struct
> *work)
> >  	case MPT2SAS_PORT_ENABLE_COMPLETE:
> >  		ioc->start_scan = 0;
> >
> > -
> > +		if (missing_delay[0] != -1 && missing_delay[1] != -1)
> > +			mpt2sas_base_update_missing_delay(ioc,
> missing_delay[0],
> > +				missing_delay[1]);
> 
> This patch is rejecting here.  It looks to be because a previous patch of yours:
> 
> commit b4730fb6e54a634a145c9c71c5cf856f00beb5cd
> Author: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Date:   Tue Dec 18 14:45:30 2012 +0100
> 
>     [SCSI] mpt2sas: fix for driver fails EEH, recovery from injected pci bus error
> 
> Added
> 
> @@ -4386,6 +4402,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER
> *ioc)
>         if (missing_delay[0] != -1 && missing_delay[1] != -1)
>                 _base_update_missing_delay(ioc, missing_delay[0],
>                     missing_delay[1]);
> +       ioc->non_operational_loop = 0;
> 
>         return 0;
> 
> I'm stopping here because correct resolution doesn't look trivial.
> 
> James
> 

Hi James,

Here is the updated patch, which will be easily patched on the latest mpt2sas code

Patch Description:

Missing delay is not getting set properly. The reason is that it is not defined in the same file from where it is being invoked.
The fix is to move the missing delay module parameter from mpt2sas_base.c to mpt2sas_scsh.c.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: stable@vger.kernel.org
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bcb23d2..c76b18b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -80,10 +80,6 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
-static int missing_delay[2] = {-1, -1};
-module_param_array(missing_delay, int, NULL, 0);
-MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
-
 static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
 	"and halt firmware - (default=0)");
@@ -2199,7 +2195,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_update_missing_delay - change the missing delay timers
+ * mpt2sas_base_update_missing_delay - change the missing delay timers
  * @ioc: per adapter object
  * @device_missing_delay: amount of time till device is reported missing
  * @io_missing_delay: interval IO is returned when there is a missing device
@@ -2210,8 +2206,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
  * delay, as well as the io missing delay. This should be called at driver
  * load time.
  */
-static void
-_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+void
+mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
 	u16 device_missing_delay, u8 io_missing_delay)
 {
 	u16 dmd, dmd_new, dmd_orignal;
@@ -4407,9 +4403,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
-	if (missing_delay[0] != -1 && missing_delay[1] != -1)
-		_base_update_missing_delay(ioc, missing_delay[0],
-		    missing_delay[1]);
 	ioc->non_operational_loop = 0;
 
 	return 0;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 4caaac1..1130197 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1055,6 +1055,9 @@ void mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_ty
 
 void mpt2sas_halt_firmware(struct MPT2SAS_ADAPTER *ioc);
 
+void mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+	u16 device_missing_delay, u8 io_missing_delay);
+
 int mpt2sas_port_enable(struct MPT2SAS_ADAPTER *ioc);
 
 /* scsih shared API */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 197ccad..7436ba8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -101,6 +101,10 @@ static ushort max_sectors = 0xFFFF;
 module_param(max_sectors, ushort, 0);
 MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 32767  default=32767");
 
+static int missing_delay[2] = {-1, -1};
+module_param_array(missing_delay, int, NULL, 0);
+MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT2SAS_MAX_LUN (16895)
 static int max_lun = MPT2SAS_MAX_LUN;
@@ -7304,7 +7308,9 @@ _firmware_event_work(struct work_struct *work)
 	case MPT2SAS_PORT_ENABLE_COMPLETE:
 		ioc->start_scan = 0;
 
-
+		if (missing_delay[0] != -1 && missing_delay[1] != -1)
+			mpt2sas_base_update_missing_delay(ioc, missing_delay[0],
+				missing_delay[1]);
 
 		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "port enable: complete "
 		    "from worker thread\n", ioc->name));
