From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Mon, 8 Jun 2015 23:47:36 +0900
Message-ID: <CAC5umyiUYYsQpc3mzx=87it+3vgxDDT+=_Y70rwac7k1Rs3eoQ@mail.gmail.com>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
	<1433324255-27510-5-git-send-email-ygardi@codeaurora.org>
	<CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
	<763dbc7b708b5d5b18ce0b5adcc41016.squirrel@www.codeaurora.org>
	<CAC5umyhWTLe_K+q9U=4M4N4Yu4Hp7hUxy4QiL=ch=JmYEiMBnQ@mail.gmail.com>
	<68c91f08f2be6c84055a303ca8aa3fe0.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <68c91f08f2be6c84055a303ca8aa3fe0.squirrel@www.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: merez@qti.qualcomm.com, dovl@qti.qualcomm.com, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Paul Bolle <pebolle@tiscali.nl>, Gilad Broner <gbroner@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Dolev Raviv <draviv@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

2015-06-08 0:32 GMT+09:00  <ygardi@codeaurora.org>:
> 1)
> If ufshcd-pltfrm driver is loaded before ufs-qcom, (what actually happens
> always), then the calling to of_platform_populate() which is added,
> guarantees that ufs-qcom probe will be called and finish, before
> ufshcd_pltfrm probe continues.

I'm worrying the case ufshcd_pltfrm_probe() is called when ufshcd-pltfrm
module is installed but ufs-qcom module is _not_ installed yet, where
ufshcd-pltfrm and ufs-qcom are both built as loadable modules.

In this case, of_platform_populate() in ufshcd_pltfrm_probe() doesn't
invoke ufs-qcom probe, does it?  So I suggested using deferred probe
infrastructure by returning -EPROBE_DEFER.

> so ufs_variant device is always there, and ready.
> I think it means we are safe - since either way, we make sure ufs-qcom
> probe will be called and finish before dealing with ufs_variant device in
> ufshcd_pltfrm probe.
>
> 2) you are right. the fix added as you suggested.

Thanks for fixing it.  But a little more work is needed in v3,
I'll leave a comment to v3.
