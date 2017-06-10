From: Guodong Xu <guodong.xu@linaro.org>
Subject: Re: [PATCH 2/3] scsi:ufs:add ufs node&reset property for hi3660
Date: Sat, 10 Jun 2017 13:13:50 +0800
Message-ID: <CAFGCpxwyMdYG-qQLDc=0G2XMaebee9DugxyE=+9Pvhf-ko59-Q@mail.gmail.com>
References: <20170610012058.33422-1-butao@hisilicon.com> <CAFGCpxwVAwJUXKbSRJBtEAGWDqykkbGnfg05h_fa0kc19JCuvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:36182 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdFJFNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jun 2017 01:13:52 -0400
Received: by mail-yw0-f180.google.com with SMTP id l75so25585573ywc.3
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jun 2017 22:13:51 -0700 (PDT)
In-Reply-To: <CAFGCpxwVAwJUXKbSRJBtEAGWDqykkbGnfg05h_fa0kc19JCuvQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: butao <butao@hisilicon.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Gengjianfeng <gengjianfeng@hisilicon.com>, Kongfei <kongfei@hisilicon.com>, Suzhuangluan <suzhuangluan@hisilicon.com>, steven.yujianfeng@hisilicon.com, zangleigang@hisilicon.com

Bu Tao,

One other issue: the 'sender' of your patchset is "butao". For
upstreaming purpose, it is recommended to use your full name, in
"first name" + "Surname" format. In your case, you need to specify it
in your commit message:

$ git commit --amend --author="Bu Tao <butao@hisilicon.com>"

You may also want to add that to your .gitconfig to save your future effort.
[user]
        name = Bu Tao
        email = butao@hisilicon.com

-Guodong


On Sat, Jun 10, 2017 at 10:44 AM, Guodong Xu <guodong.xu@linaro.org> wrote:
> Bu Tao,
>
> 1. Subject line of this patch goes something like "arm64: dts: hi3660:
> add ufs support xxx"
>
> 2. Have you run "./scripts/get_maintainer.pl *.patch" to get the
> correct maintainers to include into your patch review?
> I don't think so. Because this is a dts change, however in your
> email's to/ cc/, there is no DTS reviewers being included. Please fix
> that and resend.
>
> 3. I suppose before sending your patchset, you already tested it
> against tip kernel. For example, where your dts change can be applied?
> If they apply to my dts patchset [1], please mention it in your commit
> message. If they don't, then please tell us where.
>
> [1].  http://www.spinics.net/lists/devicetree/msg178303.html
>
> 4. Re-send, send them as "git format-patch -v2".
>
> -Guodong
>
> On Sat, Jun 10, 2017 at 9:20 AM, butao <butao@hisilicon.com> wrote:
>> add ufs node for hi3660
>>
>> Signed-off-by: Bu Tao <butao@hisilicon.com>
>> ---
>>  arch/arm64/boot/dts/hisilicon/hi3660.dtsi | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>  mode change 100644 => 100755 arch/arm64/boot/dts/hisilicon/hi3660.dtsi
>>
>> diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
>> old mode 100644
>> new mode 100755
>> index 3983086bd67b..4ba9cec43d94
>> --- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
>> +++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
>> @@ -141,6 +141,26 @@
>>                 #size-cells = <2>;
>>                 ranges;
>>
>> +                ufs: ufs@ff3b0000 {
>> +                        compatible = "jedec,ufs-1.1", "hisilicon,hi3660-ufs";
>> +                        reg = <0x0 0xff3b0000 0x0 0x1000>,      /* 0: HCI standard */
>> +                              <0x0 0xff3b1000 0x0 0x1000>;      /* 1: UFS SYS CTRL */
>> +                        interrupt-parent = <&gic>;
>> +                        interrupts = <0 278 4>;
>> +                        clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
>> +                                 <&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
>> +                        clock-names = "clk_ref", "clk_phy";
>> +                        freq-table-hz = <0 0>, <0 0>;
>> +                        resets = <&crg_rst 0x84 12>,           /* offset: 0x84; bit: 12 */
>> +                                 <&crg_rst 0x84 7>;            /* offset: 0x84; bit: 7  */
>> +                        reset-names = "rst", "assert";
>> +                        ufs-hi3660-use-rate-B;
>> +                        ufs-hi3660-broken-fastauto;
>> +                        ufs-hi3660-use-HS-GEAR3;
>> +                        ufs-hi3660-broken-clk-gate-bypass;
>> +                        status = "ok";
>> +                };
>> +
>>                 fixed_uart5: fixed_19_2M {
>>                         compatible = "fixed-clock";
>>                         #clock-cells = <0>;
>> --
>> 2.11.GIT
>>
