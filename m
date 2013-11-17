From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor code
Date: Sun, 17 Nov 2013 19:09:07 -0200
Message-ID: <CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
	<1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
>> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_ID' and
>> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going out' when
>> necessary.
>
> You pointlessly renamed a variable, which makes the diff hard to read.
> Please don't do that.

Ok, I can agree. 'len' means length? What is returned in case of non error?

>
> You missed the fact that the passed in pointer is unmodified if
> mgmt_get_if_info() returns non zero, so the kfree frees junk and would
> oops.
>
> There's no need for a goto; len = -EINVAL; does everything that's
> needed.

Well, that is a coverity catch. CID 1128954. Check it.

>
> James
>
>

Thanks.


-- 
Regards,

Geyslan G. Bem
hackingbits.com
