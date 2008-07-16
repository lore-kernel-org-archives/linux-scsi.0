From: James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
Subject: Re: [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 17:11:16 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F02E@xbl3.ma.emulex.com>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>	<487E4443.7090601@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com>
	<487E4DC6.4030108@cs.wisc.edu> <487E4FE3.8040904@cs.wisc.edu>
	<487E5157.7050709@cs.wisc.edu>
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

Yeah, I realize the scenario. What's confusing is, it's has been a
while since I've seen any cache failure message get spit out. But your
logic is pretty solid.

Anyway, your idea of converting fc_remove_host() to call
scsi_remove_target()
for all the targets prior to deleting the rports is a good one.  And the
terminate_rport_io call is already in fc_rport_final_delete().

This doesn't make sense to me though:
> then in the fcoe termniate_rport_io function we could stop the port?
If "port" means the fcoe port, and if this was the last rport, then I
guess
it kinda makes sense. But I would have assumed that the outer thread
that is
calling fc_remove_host() and scsi_remove_host() would have actually have
been the one to stop/terminate the fcoe port after making these calls.

-- james s

> Mike Christie wrote:
> I guess we have the terminate_rport_io callback already. So 
> we could do:
> 
> 
> fc_remove_host()
> for each target
> 	scsi_remove_target();
> for each rport
> 	fc_queue_work(shost, &rport->rport_delete_work);
> 
> .....
> 
> 
> fc_rport_final_delete()
> 	i->f->terminate_rport_io
> 
> .......
> 
> then in the fcoe termniate_rport_io function we could stop the port?
> 
