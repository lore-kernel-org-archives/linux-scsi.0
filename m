From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 2/3] scsi: ufs: Allow resetting the UFS device
Date: Tue, 04 Jun 2019 08:25:14 -0700
Message-ID: <5cf68d5b.1c69fb81.281cd.5f93@mx.google.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org> <20190604072001.9288-3-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604072001.9288-3-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Pedro Sousa <pedrom.sousa@synopsys.com>
Cc: Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Quoting Bjorn Andersson (2019-06-04 00:20:00)
> @@ -6104,6 +6105,25 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>         return err;
>  }
> =20
> +/**
> + ufshcd_device_reset() - toggle the (optional) device reset line
> + * @hba: per-adapter instance
> + *
> + * Toggles the (optional) reset line to reset the attached device.
> + */
> +static void ufshcd_device_reset(struct ufs_hba *hba)
> +{
> +       /*
> +        * The USB device shall detect reset pulses of 1us, sleep for 10u=
s to

This isn't usb though. Can we have a gpio reset driver and then
implement this in the reset framework instead? Or did that not work out
for some reason?

> +        * be on the safe side.
> +        */
> +       gpiod_set_value_cansleep(hba->device_reset, 1);
> +       usleep_range(10, 15);
> +
> +       gpiod_set_value_cansleep(hba->device_reset, 0);
> +       usleep_range(10, 15);
> +}
> +
>  /**
>   * ufshcd_host_reset_and_restore - reset and restore host controller
>   * @hba: per-adapter instance
