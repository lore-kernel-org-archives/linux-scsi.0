From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 2/4] scsi: ufs: add debugfs for ufs
Date: Fri, 6 Feb 2015 23:42:36 +0900
Message-ID: <CAC5umyiQYWLVn-=VyOw1cdiGdukFhh3uBTj78djb67pugYZu-w@mail.gmail.com>
References: <1422977841-25036-1-git-send-email-gbroner@codeaurora.org>
	<1422977841-25036-3-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422977841-25036-3-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

2015-02-04 0:37 GMT+09:00 Gilad Broner <gbroner@codeaurora.org>:
> From: Lee Susman <lsusman@codeaurora.org>
>
> Adding debugfs capability for ufshcd.

...

> +void ufsdbg_add_debugfs(struct ufs_hba *hba)
> +{
> +       if (!hba) {
> +               pr_err("%s: NULL hba, exiting\n", __func__);
> +               return;
> +       }
> +
> +       hba->debugfs_files.debugfs_root = debugfs_create_dir("ufs", NULL);

This creates "ufs" directory in the root of debugfs.  So if there are
two or more UFS host controllers on a single system, only the first
one can succeed.  Should we append the index for unique directory
name for each contoroller like "ufs0", "ufs1", ...?

MMC debugfs support does something similar, it creates "mmc0"
directory in the root of debugfs.
