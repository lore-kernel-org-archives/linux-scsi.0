From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc-transport: Close state transition-window during	rport
 deletion.
Date: Wed, 29 Apr 2009 12:41:32 -0500
Message-ID: <49F8914C.7050803@cs.wisc.edu>
References: <20090428140152.GA16413@plap4-2.qlogic.org> <49F71006.4060703@cs.wisc.edu> <20090428143746.GE16413@plap4-2.qlogic.org> <49F71A52.5090802@cs.wisc.edu> <20090428160110.GI16413@plap4-2.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050009010709020802080109"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54763 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZD2Rln (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 13:41:43 -0400
In-Reply-To: <20090428160110.GI16413@plap4-2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

This is a multi-part message in MIME format.
--------------050009010709020802080109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Vasquez wrote:
> On Tue, 28 Apr 2009, Mike Christie wrote:
> 
>> Andrew Vasquez wrote:
>>> On Tue, 28 Apr 2009, Mike Christie wrote:
>>>
>>>> Andrew Vasquez wrote:
>>>>> After an rport's state has transitioned to FC_PORTSTATE_BLOCKED,
>>>>> but, prior to making the upcall to 'block' the scsi-target
>>>>> associated with an rport, queued commands can recycle and
>>>>> ultimately run out of retries causing failures to propagate to
>>>>> upper-level drivers.  Close this transition-window by returning
>>>>> the non-'retries' modifying DID_IMM_RETRY status for submitted
>>>>> I/Os.
>>>>>
>>>>> Issue seen during continuous LIP-injection.
>>>>>
>>>>> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
>>>>>
>>>>> ---
>>>>>
>>>>> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
>>>>> index c9184f7..d189e0e 100644
>>>>> --- a/include/scsi/scsi_transport_fc.h
>>>>> +++ b/include/scsi/scsi_transport_fc.h
>>>>> @@ -687,6 +687,8 @@ fc_remote_port_chkready(struct fc_rport *rport)
>>>>>  	case FC_PORTSTATE_BLOCKED:
>>>>>  		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>>>>>  			result = DID_TRANSPORT_FAILFAST << 16;
>>>>> +		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
>>>>> +			result = DID_IMM_RETRY << 16;
>>>>>  		else
>>>>>  			result = DID_TRANSPORT_DISRUPTED << 16;
>>>> I think you can just remove this DID_TRANSPORT_DISRUPTED. The deletion, 
>>>> role change or re-addition code will do the right thing with the IO when 
>>>> it finishes the transition for this case.
>>> Just to be clear here, you're proposing this as an alternate?
>>>
>>> -- av
>>>
>>> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
>>> index c9184f7..a53a0fd 100644
>>> --- a/include/scsi/scsi_transport_fc.h
>>> +++ b/include/scsi/scsi_transport_fc.h
>>> @@ -688,7 +688,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
>>>  		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>>>  			result = DID_TRANSPORT_FAILFAST << 16;
>>>  		else
>>> -			result = DID_TRANSPORT_DISRUPTED << 16;
>>> +			result = DID_IMM_RETRY << 16;
>> Yeah, I think that is what we want. We originally had only 
>> DID_IMM_RETRY. When I added DID_TRANSPORT_DISRUPTED, it initially had 
>> infinite retries like DID_IMM_RETRY so the behavior was not changed. 
>> When I fixed DID_TRANSPORT_DISRUPTED to follow the cmd retries/allowed, 
>> I should have changed this code back to use DID_IMM_RETRY.
> 
> Ok, here's a final one with an updated commit message.
> 
> ---
> 
> fc-transport: Close state transition-window during rport deletion.
> 
> After an rport's state has transitioned to FC_PORTSTATE_BLOCKED,
> but, prior to making the upcall to 'block' the scsi-target
> associated with an rport, queued commands can recycle and
> ultimately run out of retries causing failures to propagate to
> upper-level drivers.  Close this transition-window by returning
> the non-'retries' modifying DID_IMM_RETRY status for submitted
> I/Os.
> 
> Issue seen during continuous LIP-injection.
> 
> Mike Christie (michaelc@cs.wisc.edu) also notes that this is a
> partial revert of f46e307da925a7b71a0018c0510cdc6e588b87fc
> ([SCSI] fc class: Add support for new transport errors), as
> follow-on transport changes now have DID_TRANSPORT_* statuses
> follow a command's retries/allowed values.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> --
> 
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index c9184f7..a53a0fd 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -688,7 +688,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
>  		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>  			result = DID_TRANSPORT_FAILFAST << 16;
>  		else
> -			result = DID_TRANSPORT_DISRUPTED << 16;
> +			result = DID_IMM_RETRY << 16;
>  		break;
>  	default:
>  		result = DID_NO_CONNECT << 16;
> 

Hey, I did the attached patch to convert the port online devloss case 
and iscsi since it will have the same problem.

--------------050009010709020802080109
Content-Type: text/plain;
 name="use-did-imm-retry.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use-did-imm-retry.patch"

>From Andrew Vasquez:

> fc-transport: Close state transition-window during rport deletion.
> 
> After an rport's state has transitioned to FC_PORTSTATE_BLOCKED,
> but, prior to making the upcall to 'block' the scsi-target
> associated with an rport, queued commands can recycle and
> ultimately run out of retries causing failures to propagate to
> upper-level drivers.  Close this transition-window by returning
> the non-'retries' modifying DID_IMM_RETRY status for submitted
> I/Os.

The same can happen for iscsi when transitioning from logged in
to failed and blocking the sdevs.

This patch converts iscsi and fc's transitions back to use DID_IMM_RETRY
instead of DID_TRANSPORT_DISRUPTED which has a limited number of retries
that we do not want to use for handling this race.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Addition of iscsi and fc port online devloss case conversion by Mike Christie


diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0b117c5..04d9da6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -357,7 +357,7 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
 		err = 0;
 		break;
 	case ISCSI_SESSION_FAILED:
-		err = DID_TRANSPORT_DISRUPTED << 16;
+		err = DID_IMM_RETRY << 16;
 		break;
 	case ISCSI_SESSION_FREE:
 		err = DID_TRANSPORT_FAILFAST << 16;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index c9184f7..68a8d87 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -680,7 +680,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
 		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
-			result = DID_TRANSPORT_DISRUPTED << 16;
+			result = DID_IMM_RETRY << 16;
 		else
 			result = DID_NO_CONNECT << 16;
 		break;
@@ -688,7 +688,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
 		if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
 			result = DID_TRANSPORT_FAILFAST << 16;
 		else
-			result = DID_TRANSPORT_DISRUPTED << 16;
+			result = DID_IMM_RETRY << 16;
 		break;
 	default:
 		result = DID_NO_CONNECT << 16;

--------------050009010709020802080109--
