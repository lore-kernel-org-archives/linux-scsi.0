From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 2/3] scsi: ufs: Allow resetting the UFS device
Date: Tue, 4 Jun 2019 15:20:10 -0700
Message-ID: <20190604222010.GC4814@minitux>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
 <20190604072001.9288-3-bjorn.andersson@linaro.org>
 <5cf68d5b.1c69fb81.281cd.5f93@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5cf68d5b.1c69fb81.281cd.5f93@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue 04 Jun 08:25 PDT 2019, Stephen Boyd wrote:

> Quoting Bjorn Andersson (2019-06-04 00:20:00)
> > @@ -6104,6 +6105,25 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
> >         return err;
> >  }
> >  
> > +/**
> > + ufshcd_device_reset() - toggle the (optional) device reset line
> > + * @hba: per-adapter instance
> > + *
> > + * Toggles the (optional) reset line to reset the attached device.
> > + */
> > +static void ufshcd_device_reset(struct ufs_hba *hba)
> > +{
> > +       /*
> > +        * The USB device shall detect reset pulses of 1us, sleep for 10us to
> 
> This isn't usb though.

No, it is not.

> Can we have a gpio reset driver and then
> implement this in the reset framework instead? Or did that not work out
> for some reason?
> 

The reset DT binding document clearly describes that resets are for
chip-internal resets, and this is a general purpose (output-only) pad on
the SoC that's connected to the reset pin on the UFS memory.

I actually see nothing preventing you to connect said reset pin to any
other GPIO.

Regards,
Bjorn

> > +        * be on the safe side.
> > +        */
> > +       gpiod_set_value_cansleep(hba->device_reset, 1);
> > +       usleep_range(10, 15);
> > +
> > +       gpiod_set_value_cansleep(hba->device_reset, 0);
> > +       usleep_range(10, 15);
> > +}
> > +
> >  /**
> >   * ufshcd_host_reset_and_restore - reset and restore host controller
> >   * @hba: per-adapter instance
