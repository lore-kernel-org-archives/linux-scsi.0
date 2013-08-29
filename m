From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH V2 1/3] scsi: ufs: Allow vendor specific initialization
Date: Thu, 29 Aug 2013 23:00:53 +0530
Message-ID: <CALMYJDtp37FfreO2WdX7m=aynGJVcxV1nTeCisC9cSmD+Z1Bew@mail.gmail.com>
References: <1377577093-10068-1-git-send-email-sthumma@codeaurora.org> <1377577093-10068-2-git-send-email-sthumma@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1377577093-10068-2-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>
> +static int ufshcd_variant_hba_init(struct ufs_hba *hba)
> +{
> +       int err = 0;
> +
> +       if (!hba->vops)
> +               goto out;
> +
> +       if (hba->vops->init) {
> +               err = hba->vops->init(hba);
> +               if (err)
> +                       goto out;
> +       }
> +
> +       if (hba->vops->setup_clocks) {
> +               err = hba->vops->setup_clocks(hba, true);
> +               if (err)
> +                       goto out_exit;
> +       }
> +
> +       if (hba->vops->setup_regulators) {
> +               err = hba->vops->setup_regulators(hba, true);
> +               if (err)
> +                       goto out_clks;
> +       }
> +
> +       goto out;
> +
> +out_clks:
> +       if (hba->vops->setup_clocks)
> +               hba->vops->setup_clocks(hba, false);
> +out_exit:
> +       if (hba->vops->exit)
> +               hba->vops->exit(hba);
> +out:
> +       if (err)
> +               dev_err(hba->dev, "%s: variant %s init failed err %d\n",
> +                       __func__, hba->vops ? hba->vops->name : "", err);
                                              ^^^^^^^
a minor comment, 'hba->vops' will not be NULL here,

> +       return err;
> +}
> +


-- 
~Santosh
