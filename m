From: John Stultz <john.stultz@linaro.org>
Subject: Re: [EXT] [PATCH 2/3] scsi: ufs: Allow resetting the UFS device
Date: Tue, 4 Jun 2019 11:10:01 -0700
Message-ID: <CANcMJZB+bg9LWzo=EaL-QnWiL49=MzyBJy8qsBiSMu8HZeWRxw@mail.gmail.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <20190604072001.9288-3-bjorn.andersson@linaro.org> <BN7PR08MB568450B1EC51ABAA2E426AC0DB150@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB568450B1EC51ABAA2E426AC0DB150@BN7PR08MB5684.namprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Subhash Jadavani <subhashj@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 4, 2019 at 1:14 AM Bean Huo (beanhuo) <beanhuo@micron.com> wrote:
>
> Hi, Bjorn
>
> >Acquire the device-reset GPIO and toggle this to reset the UFS device during
> >initialization and host reset.
> >
> >+/**
> >+ ufshcd_device_reset() - toggle the (optional) device reset line
> >+ * @hba: per-adapter instance
> >+ *
> >+ * Toggles the (optional) reset line to reset the attached device.
> >+ */
> >+static void ufshcd_device_reset(struct ufs_hba *hba) {
> >+      /*
> >+       * The USB device shall detect reset pulses of 1us, sleep for 10us to
> >+       * be on the safe side.
> >+       */
> >+      gpiod_set_value_cansleep(hba->device_reset, 1);
> >+      usleep_range(10, 15);
> >+
> >+      gpiod_set_value_cansleep(hba->device_reset, 0);
> >+      usleep_range(10, 15);
> >+}
> >+
> > /**
> >  * ufshcd_host_reset_and_restore - reset and restore host controller
> >  * @hba: per-adapter instance
> >@@ -6159,6 +6179,9 @@ static int ufshcd_reset_and_restore(struct ufs_hba
> >*hba)
> >       int retries = MAX_HOST_RESET_RETRIES;
> >
> >       do {
> >+              /* Reset the attached device */
> >+              ufshcd_device_reset(hba);
> >+
>
> what's problem you met, and you should reset UFS device here? could you give more info?

On the pixel3, devices with micron UFS chips won't boot upstream
kernels without this patch, which is a rewrite of an earlier patch:
  https://git.linaro.org/people/john.stultz/android-dev.git/commit/?h=dev/p3&id=99f3dd8519a848b752679584451c45f42c326a17

Which was pulled from the downstream tree from here:
  https://android.googlesource.com/kernel/msm.git/+/9c8077087e818017%5E%21/

CCing Subhash as he may have additional context.

thanks
-john
