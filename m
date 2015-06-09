From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] scsi: ufs: probe and init of variant driver from
 the platform device
Date: Tue, 9 Jun 2015 07:53:28 -0500
Message-ID: <CAL_Jsq+SWq9=xTjVvQH2tMoq=g_rjk44A7T4TMFKvDiUp_ahCg@mail.gmail.com>
References: <1433324255-27510-1-git-send-email-ygardi@codeaurora.org>
 <1433324255-27510-5-git-send-email-ygardi@codeaurora.org> <CAC5umyis6HU06KU-aSGoy6mCt-u+5Pz16nDk1qHrcsTnFo_2hA@mail.gmail.com>
 <763dbc7b708b5d5b18ce0b5adcc41016.squirrel@www.codeaurora.org>
 <CAC5umyhWTLe_K+q9U=4M4N4Yu4Hp7hUxy4QiL=ch=JmYEiMBnQ@mail.gmail.com>
 <68c91f08f2be6c84055a303ca8aa3fe0.squirrel@www.codeaurora.org>
 <CAL_JsqKYqZyayzN3imi55EFP=ao4NTSgfXjP5J5rSxMAg4ZSMA@mail.gmail.com> <bfade46f9d953e10240acb835105b81d.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bfade46f9d953e10240acb835105b81d.squirrel-mMfbam+mt9083fI46fginR2eb7JE58TQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dov Levenglick <dovl-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, merez-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org, dovl-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org, Jej B <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm <linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Santosh Y <santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 9, 2015 at 12:53 AM, Dov Levenglick <dovl-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>> On Sun, Jun 7, 2015 at 10:32 AM,  <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>>>> 2015-06-05 5:53 GMT+09:00  <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>:

[...]

>>> If ufshcd-pltfrm driver is loaded before ufs-qcom, (what actually
>>> happens
>>> always), then the calling to of_platform_populate() which is added,
>>> guarantees that ufs-qcom probe will be called and finish, before
>>> ufshcd_pltfrm probe continues.
>>> so ufs_variant device is always there, and ready.
>>> I think it means we are safe - since either way, we make sure ufs-qcom
>>> probe will be called and finish before dealing with ufs_variant device
>>> in
>>> ufshcd_pltfrm probe.
>>
>> This is due to the fact that you have 2 platform drivers. You should
>> only have 1 (and 1 node). If you really think you need 2, then you
>> should do like many other common *HCIs do and make the base UFS driver
>> a set of library functions that drivers can use or call. Look at EHCI,
>> AHCI, SDHCI, etc. for inspiration.
>
> Hi Rob,
> We did look at SDHCI and decided to go with this design due to its
> simplicity and lack of library functions. Yaniv described the proper flow
> of probing and, as we understand things, it is guaranteed to work as
> designed.
>
> Furthermore, the design of having a subcore in the dts is used in the
> Linux kernel. Please have a look at drivers/usb/dwc3 where - as an example
> - both dwc3-msm and dwc3-exynox invoke the probing function in core.c
> (i.e. the shared underlying Synopsys USB dwc3 core) by calling
> of_platform_populate().

That binding has the same problem. Please don't propagate that. There
is no point in a sub-node in this case.

> Do you see a benefit in the SDHCi implementation?

Yes, it does not let the kernel driver design dictate the hardware description.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
