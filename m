From: "sayali" <sayalil@codeaurora.org>
Subject: RE: [PATCH V2 1/3] scsi: ufs: set the device reference clock setting
Date: Thu, 14 Jun 2018 17:03:27 +0530
Message-ID: <000101d403d3$87210d20$95632760$@codeaurora.org>
References: <1528455990-24572-1-git-send-email-sayalil@codeaurora.org> <1528455990-24572-2-git-send-email-sayalil@codeaurora.org> <20180612192636.GA31725@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612192636.GA31725@rob-hp-laptop>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Rob Herring' <robh@kernel.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, linux-scsi@vger.kernel.org, 'Mark Rutland' <mark.rutland@arm.com>, 'Mathieu Malaterre' <malat@debian.org>, "'open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS'" <devicetree@vger.kernel.org>, 'open list' <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Comment inline.

Thanks,
Sayali
-----Original Message-----
From: Rob Herring [mailto:robh@kernel.org] 
Sent: Wednesday, June 13, 2018 12:57 AM
To: Sayali Lokhande <sayalil@codeaurora.org>
Cc: subhashj@codeaurora.org; cang@codeaurora.org;
vivek.gautam@codeaurora.org; rnayak@codeaurora.org; vinholikatti@gmail.com;
jejb@linux.vnet.ibm.com; martin.petersen@oracle.com;
asutoshd@codeaurora.org; evgreen@chromium.org; linux-scsi@vger.kernel.org;
Mark Rutland <mark.rutland@arm.com>; Mathieu Malaterre <malat@debian.org>;
open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
<devicetree@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] scsi: ufs: set the device reference clock
setting

On Fri, Jun 08, 2018 at 04:36:28PM +0530, Sayali Lokhande wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> UFS host supplies the reference clock to UFS device and UFS device 
> specification allows host to provide one of the 4 frequencies (19.2 
> MHz,
> 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the 
> device reference clock frequency setting in the device based on what 
> frequency it is supplying to UFS device.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  7 +++
>  drivers/scsi/ufs/ufs.h                             |  9 ++++
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 24 ++++++++++
>  drivers/scsi/ufs/ufshcd.c                          | 52
++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h                          |  1 +
>  5 files changed, 93 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt 
> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index c39dfef..4522434 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -41,6 +41,12 @@ Optional properties:
>  -lanes-per-direction	: number of lanes available per direction - either 1
or 2.
>  			  Note that it is assume same number of lanes is
used both
>  			  directions at once. If not specified, default is 2
lanes per direction.
> +- dev-ref-clk-freq	: Specify the device reference clock frequency, must
be one of the following:
> +			  0: 19.2 MHz
> +			  1: 26 MHz
> +			  2: 38.4 MHz
> +			  3: 52 MHz
> +			  Defaults to 26 MHz if not specified.

I must have misunderstood your last response. I thought you could handle
things without DT. If not, my question remains.
[Sayali]: Ref clk frequency setting could vary from
platfrom-to-platform(vendor specific). Hence we need to pass it via DT.
	Currently in DT we do not set/mention any ref clk frequency
parameter. Hence I have added one new DT entry to configure
	required ref clk freq.

Rob
