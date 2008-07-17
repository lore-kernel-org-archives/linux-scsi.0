From: James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
Subject: Re: [PATCH 1/1] libfc: fix queue command rport checks
Date: Thu, 17 Jul 2008 09:43:47 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F04D@xbl3.ma.emulex.com>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>	<487E4443.7090601@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com>
	<487E4DC6.4030108@cs.wisc.edu> <487E4FE3.8040904@cs.wisc.edu>
	<487E5157.7050709@cs.wisc.edu>
	<D1D4C3FF75F9354393DB8314DF43DEF2E7F02E@xbl3.ma.emulex.com>
	<487E66A4.9030601@cs.wisc.edu>
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

 

Mike Christie wrote:
> So I thought it if we could do the cleanup in some callout after the 
> target is removed but before the rport is freed. I think I 
> meant to do 
> this in the dev_loss_tmo_callbk(). qla2xxx was allocating its 
> own rport 
> struct and is freeing it in dev_loss_tmo_callbk(). For fcoe 
> we are just 
> using the scsi_transport_fc rport it the dd_data, but I was 
> thinking if 
> we needed to cleanup some other rport resrouces we could do 
> it from the 
> dev_loss_tmo_callbk().

yep - the callback is when the rport struct is really done with, so
this seems right.

-- james s
