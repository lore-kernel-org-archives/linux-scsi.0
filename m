From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/3] add support for DWC UFS Host Controller
Date: Mon, 8 Feb 2016 15:17:11 +0000
Message-ID: <56B8B177.2050000@synopsys.com>
References: <cover.1454498292.git.jpinto@synopsys.com>
 <2072510.CA47OHQsUN@wuerfel> <56B2164E.5060007@synopsys.com>
 <2087303.0ORDEBS3hn@wuerfel> <56B222C8.5010509@synopsys.com>
 <20160204162700.GD17587@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204162700.GD17587@leverpostej>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, santosh.sy-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, h.vinayak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Mark and Arnd,

I am planning the v2 of this patch set. I have a doubt in the version
compatibility strings... The core driver must support the UFS 2.0 controller and
this patch set includes a patch that adds 2.0 capabilities to it. The core
driver can get from the controller's version and with that use or not a specific
2.0 feature.

What would be the real added-value of having a compatibility string like
"snps,ufshcd-1.1" and "snps,ufshcd-2.0" if the driver can perform as 2.0 if it
detects a 2.0 controller? Are you saying that a user that puts "snps,ufshcd-1.1"
in the DT compatibility string disables the UFS 2.0 in the core driver despite
the controller is 2.0? Please clarify.

Thanks,
Joao

On 2/4/2016 4:27 PM, Mark Rutland wrote:
> On Wed, Feb 03, 2016 at 03:54:48PM +0000, Joao Pinto wrote:
>> Hi,
>>
>> On 2/3/2016 3:39 PM, Arnd Bergmann wrote:
>>> On Wednesday 03 February 2016 15:01:34 Joao Pinto wrote:
>>>>
>>>> Hi Arnd,
>>>>
>>>> On 2/3/2016 12:54 PM, Arnd Bergmann wrote:
>>>>> On Wednesday 03 February 2016 11:28:26 Joao Pinto wrote:
>>>>>>
>>>>>> Signed-off-by: Joao Pinto <jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
>>>>>
>>>>> This needs a changelog comment, like every patch.
>>>>>
>>>>>> @@ -0,0 +1,16 @@
>>>>>> +* Universal Flash Storage (UFS) DesignWare Host Controller
>>>>>> +
>>>>>> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
>>>>>> +Each UFS controller instance should have its own node.
>>>>>> +
>>>>>> +Required properties:
>>>>>> +- compatible        : compatible list, contains "snps,ufshcd"
>>>>>
>>>>> Are there multiple versions of this controller? Usually for designware
>>>>> parts the version is known, so we should document which versions exist
>>>>
>>>> This controller recent releases was 2.0, but we released last year 1.1. The
>>>> driver works with both. The driver must work with all DWC UFS versions.
>>>
>>> Ok, then make the driver match on the "snps,ufshcd-1.1" compatible
>>> string, but document both strings in the binding document, and make
>>> it mandatory to specify the 1.1 version as a compatible fallback.
>>>
>>> If we ever need to handle a quirk for the 2.0 version then, it can
>>> easily be done.
>>
>> We need the driver to support UFS 2.0 because it is our latest release and is
>> the done that Synopsys is focused now. We could call it "snps, ufshcd-2.0" then.
>> What do you think?
> 
> Arnd's point was that the driver can handle only "snps,ufshcd-1.1" for
> now, and in your DT you can have:
> 
> 	compatible = "snps,ufshcd-2.0", "snps,ufshcd-1.1";
> 
> That allows driver to handle 2.0 and 1.1 without knowing anything about
> 2.0 for now. If in future the two need to be handled differently we can
> update the driver to explicitly match "snps,ufshcd-2.0".
> 
> Regardless, both compatible string should go in the documentation, and
> it should be explicitly mentioned that "snps,ufshcd-1.1" should be used
> as a fallback entry.
> 
> Mark.
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
