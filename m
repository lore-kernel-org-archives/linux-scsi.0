From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 13/13] scsi: ufs: Add exynos ufs platform data
Date: Mon, 5 Oct 2015 09:11:33 -0500
Message-ID: <CAL_JsqJWzqMkkMH8myFX1eeuV-U25Ri_nWhjj2mb3AWh5tzDZA@mail.gmail.com>
References: <201510011845.GN7Kisc4%fengguang.wu@intel.com> <1790578.NZeHVGuJeN@wuerfel>
 <56123165.2060500@samsung.com> <14885029.SsJgQkuPcG@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14885029.SsJgQkuPcG@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, kbuild test robot <lkp@intel.com>, kbuild-all@01.org, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, vinayak holikatti <vinholikatti@gmail.com>, Amit Kachhap <amit.daniel@samsung.com>, Seungwon Jeon <essuuj@gmail.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 5, 2015 at 4:06 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 05 October 2015 13:44:29 Alim Akhtar wrote:
>> CCing Rob Herring,
>>
>> Hi Arnd,
>>
>> On 10/01/2015 04:59 PM, Arnd Bergmann wrote:
>> > On Thursday 01 October 2015 18:46:34 kbuild test robot wrote:
>> >> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
>> >>
>> >> config: x86_64-allmodconfig (attached as .config)
>> >> reproduce:
>> >>          git checkout 6e153e3bf7c68b019e987c5a0ffadebd9c7d4fbb
>> >>          # save the attached .config to linux build tree
>> >>          make ARCH=x86_64
>> >>
>> >> All error/warnings (new ones prefixed by >>):
>> >>
>> >>>> ERROR: "ufs_hba_exynos_ops" [drivers/scsi/ufs/ufshcd-pltfrm.ko] undefined!
>> >>
>> >>
>> >
>> > Ah, this seems to be a case of layering violation. It would be best to
>> > restructure the code so that the exynos driver registers a platform_driver
>> > by itself for the respective DT compatible string, and then calls
>> > into the common code from its probe function, rather than having the
>> > generic driver know about the specific backends.
>> >
>> > That approach will also make the generic driver more scalable as we
>> > add further chip-specific variations, and matches what we do in other
>> > drivers.
>> >
>>
>> Looks like some discussions on ufs variant driver probe method happened
>> here [1] few months back.
>> [1]-> https://lkml.org/lkml/2015/6/3/180
>
> Hmm, too bad we didn't catch it then, it's much more work to fix now.

What you suggested is what is being implemented[1]. It is not merged
yet. The core is a library and the platform specific parts create the
driver.

Rob

[1] https://lkml.org/lkml/2015/9/2/364
