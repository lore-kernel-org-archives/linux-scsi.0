From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 15:55:25 -0500
Message-ID: <487E603D.1040202@cs.wisc.edu>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu>	<487E4443.7090601@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com>	<487E4DC6.4030108@cs.wisc.edu>
	<487E4FE3.8040904@cs.wisc.edu>	<D1D4C3FF75F9354393DB8314DF43DEF2E7F025@xbl3.ma.emulex.com>
	<487E5ED6.9040302@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <487E5ED6.9040302-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
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

Mike Christie wrote:
> James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org wrote:
>>  
>>
>>> -----Original Message-----
>>> From: Mike Christie [mailto:michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org] 
>>>
>>>> So during a clean shutdown are drivers supposed to remove 
>>> the targets by 
>>>> calling scsi_remove_target to remove the devices, then 
>>> remove the rports 
>>>> through the class?
>>> Or for the case where we are stopping a host (rmmod or single 
>>> host stop 
>>> like with fcoe), should drivers call
>> Yes - the steps below is what the drivers do today.  And this does all
>> work without failing the cache sync (unless something's changed recently
>> in the midlayer above us).
> 
> You mean if I do rmmod lpfc it should work today? I do not think it 
> works anymore because in fc_remove_host we do this:
> 
> fc_remove_host()
> 
>          /* Remove any remote ports */
>          list_for_each_entry_safe(rport, next_rport,
>                          &fc_host->rports, peers) {
>                  list_del(&rport->peers);
>                  rport->port_state = FC_PORTSTATE_DELETED;
>                  fc_queue_work(shost, &rport->rport_delete_work);
>          }
> 
> 
> We set the rport->port_state to deleted before removing the target, so 
> when the cache sync is sent later as a result of fc_rport_final_delete 
> calling scsi_remove_target, the fc_remote_port_chkready checks in lpfc 
> or qla2xxx or mpt's queeucommand will fail the command with 
> DID_NO_CONNECT (fc_remote_port_chkready will
>

oops that got cut off. I mean to write fc_remote_port_chkready will do this:

fc_remote_port_chkready(struct fc_rport *rport)
{
         int result;

         switch (rport->port_state) {
         case FC_PORTSTATE_ONLINE:
                 if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
                         result = 0;
                 else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
                         result = DID_IMM_RETRY << 16;
                 else
                         result = DID_NO_CONNECT << 16;
                 break;
         case FC_PORTSTATE_BLOCKED:
                 result = DID_IMM_RETRY << 16;
                 break;
         default:
                 result = DID_NO_CONNECT << 16;
                 break;


So because port_state == FC_PORTSTATE_DELETED we reutrn DID_NO_CONNECT 
on any IO like the cache sync that gets sent.
