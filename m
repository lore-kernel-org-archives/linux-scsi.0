From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 14:36:38 -0500
Message-ID: <487E4DC6.4030108@cs.wisc.edu>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>
	<487E4443.7090601@cs.wisc.edu>
	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F01C-0GoafHKvaWWVoqRKY1PiFtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org wrote:
>  
> 
>> michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org wrote:
>> Oh yeah, I ccd linux-scsi for this patch and not others, 
>> because JamesS 
>> and them are not on fcoe devel list, and it seems like all fc drivers 
>> fail the sync cache command.
>>
>> What happens is that we remove the rport which sets the rport state, 
>> then the fc class removes the target. This causes the target and its 
>> devices to be removed, which can cause a sync cache to be sent. But 
>> because the the rport is not in the online state it will fail 
>> the command.
> 
> Well, excepting detachment paths, if we're tearing the rport down, it's
> because
> we've already lost connectivity to the target, so there's no way a sync
> cache would ever succeed. It's a suprise-removal scenario.
> 

Yeah, I am only talking about the paths where we want a clean shutdown 
like if for fcoe we did echo ethX > /sys/module/fcoe/destroy. For normal 
fc do we want to be able to remove rpots too? Did you guys do that with 
the ioctl modules before? Then there is the module removal case. I think 
for module removal we want a clean shutdown too, but I am not sure if 
other people feel that for module removal there are gaurantees like that.

So during a clean shutdown are drivers supposed to remove the targets by 
calling scsi_remove_target to remove the devices, then remove the rports 
through the class?
