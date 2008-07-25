From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Poisoning of Linux initiators on SCST reboot.
Date: Fri, 25 Jul 2008 14:43:56 +0400
Message-ID: <4889AE6C.40900@vlnb.net>
References: <200807241750.m6OHophm028516@wind.enjellic.com> <4889AD80.30000@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:53305 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750706AbYGYKn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2008 06:43:58 -0400
In-Reply-To: <4889AD80.30000@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: linux-driver@qlogic.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> greg@enjellic.com wrote:
>> Good morning to everyone, hope your respective days are going well.
>> Sorry for the wide cast on this but I wanted to get what would seem to
>> be the concerned parties on this issue in the loop.
>>
>> We have been putting SCST through an extensive round of pre-production
>> testing.  I wanted to start following up on some of the issues we have
>> noted.
>>
>> We will be putting SCST into service to support mirrored storage from
>> client initiators to two separate data-centers.  The filesystems on
>> the client initiators access storage at the two data-centers via a
>> Linux MD RAID1 device.  The SAN architecture is based on Cisco
>> MDS-9509 switches.
>>
>> Just as an aside for people considering use of SCST.  The core engine
>> has been rock solid.  Our testing rounds consists of driving around
>> 1/8 of a petabyte of widely disparate I/O types from multiple
>> initiators to a pair of targets in the two data-centers.  SCST hasn't
>> missed a beat so far, so kudos to Vlad and everyone involved in its
>> development.
> 
> Thanks! Your support is very much appreciated and exactly on time, 
> because I'm going to submit SCST patches for review and inclusion into 
> the kernel next week.
> 
>> As we began forced failure testing one issue has come up that I wanted
>> to advise people of.  A hard reboot of an SCST target server results
>> in the 'poisoning' of Linux based initiators.  We verified the issue
>> as being present on client initiators running the stock RHEL5 kernel
>> up through 2.6.26.
>>
>> The targets are using Qlogic 2462 cards using the isp_mod driver.  The
>> client initiators are using Qlogic 2342 cards with the qla2xxx driver.
>>
>> Failure mode is as follows:
>>
>>         1.) Configure SCST based storage for an initiator (vdisk
>>             based).
>>
>>         2.) Activate initiator.  Initiator logs into fabric and
>>             discovers SCST based storage.
>>
>>         3.) Force SCST target failure by rebooting or pulling power.
>>
>>         4.) SCST target returns to service and logs into zone.
>>
>>         5.) Initiator picks up RSCN but re-activates the rport for
>>             SCST server as an INITIATOR rather than TARGET role.
>>
>> After this point in time the initiator is effectively 'poisoned'.
>>
>> Nothing short of unloading and reloading the Qlogic 2xxx driver on the
>> client initiator will allow the initiator to recognize the SCST server
>> as a target device.  A driver unload/reload of course is not an option
>> to restore connectivity since it would take the remaining live side of
>> the mirror off-line as well.
>>
>> We finally figured out what seems to be happening by watching the logs
>> on the client and comparing what was going on there to the FLOGI login
>> status on the fabric.
>>
>> When the SCST target server reboots the initiator times out the remote
>> port and places it into 'unknown' state.  The qla2xxx driver,
>> according to the source code, maintains the previous rport state in
>> driver internal data.
>>
>> The 2462 card in the target on boot logs into the fabric with an
>> initiator role, I'm assuming in support of BIOS based SAN booting. The
>> client initiator picks up on this and re-activates the rport as being
>> in an INITIATOR role.
> 
> You should be able to switch off this behavior by disabling the SAN 
> booting in the card's BIOS.
> 
>> Loading the isp_mod driver causes the 2462 card in the target to be
>> shutdown.  The client initiator picks up on this and times out the
>> rport retaining the last rport state as INITIATOR.
>>
>> Enabling target mode on the 2462 causes it to log back into the
>> fabric.  The client initiator picks up on the RSCN but refuses to
>> transition the rport from INITIATOR to TARGET state.  Without going
>> into TARGET state the remote port won't have SCSI device discovery
>> initiated against it and hence the SCST based storage is inaccessible.
>>
>> Activating a LIP on the client initiates a new fabric login attempt
>> which completes with the following message:
>>
>> Jul 24 02:53:59 init-test kernel: rport-2:0-0: blocked FC remote port
>> time out: no longer a FCP target, removing starget
>>
>> Which from a review of the source code seems consistent with our
>> analysis of the problem.
>>
>> The culprit is the following code from drivers/scsi/scsi_transport_fc.c:
>>
>>         if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
>>             (rport->scsi_target_id != -1) &&
>>             !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
>>                 dev_printk(KERN_ERR, &rport->dev,
>>                         "blocked FC remote port time out: no longer"
>>                         " a FCP target, removing starget\n");
>>                 spin_unlock_irqrestore(shost->host_lock, flags);
>>                 scsi_target_unblock(&rport->dev);
>>                 fc_queue_work(shost, &rport->stgt_delete_work);
>>                 return;
>>         }
>>
>> The above gets executed in response to the LIP on the initiator.  The
>> value in rport->roles is being populated with what the remote target
>> was INITIATOR rather than its current TARGET state.
>>
>> Windows client initiators running against the SCST targets get the
>> transition and login sequence correct.  When the SCST target is
>> re-activated after the cold boot those clients immediately re-discover
>> their storage while the Linux clients issue error messages about loss
>> of the remote target.
>>
>> While all this doesn't seem to be technically a bug with SCST it
>> certainly is a problematic usage scenario.  It may also explain why
>> some individuals may have had problems getting SCST clients to access
>> their storage.
>>
>> If a test SCST server was plugged into an active zone and turned on it
>> would immediately poison any Linux clients.  No amount of proper
>> configuration on the target would allow the client to access storage
>> until the client was rebooted or its drivers reloaded.
>>
>> Any suggestions on how to move forward would be appreciated.  We've
>> got a pretty extensive test environment and would be happy to test run
>> any suggested changes or patches.
> 
> I've also many times seen how Linux Qlogic qla2xxx driver "lost" remote 
> ports. But that was from the target side and I wasn't able to figure out 
> the exact test case for that. Plus, we found out a suitable for target 
> workaround: usage of INITIATOR PORT NAME field in ATIO IOCB for the lost 
> ports.
> 
> So, qla2xxx driver definitely has problem(s) in this area. The fact that 
> Windows works well in this scenario only additionally proves that. But 
> I'm afraid, you have the only way to deal with it is to fix qla2xxx 
> driver itself.

Sorry, I meant "yourself".

> My experience with contacts with Andrew Vasquez, the 
> driver's maintainer, that you need something more valuable than problems 
> with some home brewed target to make him interested. Otherwise your 
> questions will be simply ignored.
> 
>> Once again a thank you to everyone who has contributed to SCST
>> development.  Other than this and a few additional glitches I will
>> follow up with via additional e-mails it is presenting itself as a
>> very solid platform for storage delivery.
>>
>> Best wishes for a pleasant weekend to everyone.
>>
>> As always,
>> Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
>> 4206 N. 19th Ave.           Specializing in information infra-structure
>> Fargo, ND  58102            development.
>> PH: 701-281-1686
>> FAX: 701-281-3949           EMAIL: greg@enjellic.com
>> ------------------------------------------------------------------------------
>> "Much work remains to be done before we can announce our total failure
>>  to make any progress."
>>                                 -- Mike Kelly
>>
>> -------------------------------------------------------------------------
>> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
>> Build the coolest Linux based applications with Moblin SDK & win great prizes
>> Grand prize is a trip for two to an Open Source event anywhere in the world
>> http://moblin-contest.org/redirect.php?banner_id=100&url=/
>> _______________________________________________
>> Scst-devel mailing list
>> Scst-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/scst-devel
>>
> 
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

