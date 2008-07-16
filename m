From: James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
Subject: Re: [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 16:07:16 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F025@xbl3.ma.emulex.com>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>	<487E4443.7090601@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com>
	<487E4DC6.4030108@cs.wisc.edu> <487E4FE3.8040904@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
content-class: urn:content-classes:message
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

 

> -----Original Message-----
> From: Mike Christie [mailto:michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org] 
> 
> > So during a clean shutdown are drivers supposed to remove 
> the targets by 
> > calling scsi_remove_target to remove the devices, then 
> remove the rports 
> > through the class?
> 
> Or for the case where we are stopping a host (rmmod or single 
> host stop 
> like with fcoe), should drivers call

Yes - the steps below is what the drivers do today.  And this does all
work without failing the cache sync (unless something's changed recently
in the midlayer above us).

> 
> 1. fc_remove_host()
> 	This could be modified to cleanup shutdown targets then 
> remove rports. 
> We could then have a rport shutdown callback which the class 
> could call 
> and drivers could cleanup and shutdown the rport here before 
> it is freed.

Is this related to your new scsi-target block code ?
Yes - agree with your comment - we can change it so that it cleansup
the blocked target, then terminates the rport.
> 
> 2. scsi_remove_host()
> 
> 3. cleanup internal host resources.
> 
> 4. scsi_put_host().
> 


-- james
