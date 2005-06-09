From: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
Subject: Re: [PATCH] for Deadlock in transport_fc
Date: Thu, 09 Jun 2005 15:47:45 +0200
Message-ID: <42A84881.6000309@fujitsu-siemens.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F404B@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:4224 "EHLO
	dgate1.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S262398AbVFINrv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 09:47:51 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F404B@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org

James.Smart@Emulex.Com wrote:
>>currently I'm trying to use the new transport_fc to read the
>>very often changing FibreChannel configuration in a test system.
>>
>>To avoid a growing list of consistent binding entries (which
>>make no sense in this special case), I tried to switch off this
>>feature by
>>     "echo none > /sys/class/fc_host/host1/tgtid_bind_type"
>>
>>Unfortunately, the system stalls immediately, I guess the reason
>>is store_fc_private_host_tgtid_bind_type() calling
>>fc_rport_terminate() while holding host_lock.
> 
> 
> Yep. A rather blatant lock bug that slipped through due to testing
> on a non-smp box.  Try the attached patch.

Thank you, it works fine.

> 
> 
>>If I understand the code correctly, even if tgtid_bind_type
>>would work correctly, still the rport-nummer and scsi-target-id
>>would count up on configuration changes. In the lpfc-driver, I
>>saw:
>>#define MAX_FCP_TARGET              256     /* max num of FCP 
>>targets supported */
>>Will this result in problems after 256 configuration changes?
>>If so, what could I do?
> 
> 
> Yes, it will. Once the target id assignment became larger than 256,
> scsi scans won't see the remote port.
> 
> I admit, a more difficult implementation is possible if this is a
> goal. In general, a production system will always manage devices
> by wwpn assignments, and will usually use fabric zoning to minimize
> it's view. Thus, a configuration such as yours, with high variability
> in the fabric, is unusual.
> 
> I'm open to a different implementation if deemed necessary.

Meanwhile I understood, that using "port_id" instead of "none"
does the trick for us. Now the scsi target numbers are restricted to
the number of fabric-ports used in the test. That always is less than
256 in our configuration.

So, for me there is no need to change anything.

> 
> 
>>BTW: My Emulex boards do not recognize a change behind the
>>FibreChannel switch. So I force them to scan the configuration
>>using "echo [01] >/sys/class/scsi_host/host1/board_online".
>>Is there a better way to do this?
> 
> 
> This is an issue worth noting. The lpfc driver registers for RSCN
> events, so it should be seeing changes. There could be switch issues
> in not posting the RSCN's (rare, long-time ago). The driver does
> qualify it's nameserver request by FC4 type of FCP. Is the device in
> question registering as an FCP type device with the fabric ?
> Please follow up on this. This should not be happening.
> 
> Also - tweaking the lpfc-specific board_online attribute is a little
> odd to make things scan. It resets and restarts the entire adapter.
> For a link rescan, we recommend that bounce the link via
> "echo 1 > sys/class/scsi_host/host1/issue_lip". If all you needed was
> a scsi scan - try "echo "- - -"  > /sys/class/scsi_host/host2/scan ".

Thank you for the explanations. We tested a bit more and found out, that
one has to wait lpfc_nodev_tmo seconds between disconnecting one target
from the fabric and connecting the other.
As this might be done quite fast in our tests, we now set lpfc_nodev_tmo
to 1, and it seems to work fine. Is there any risk with such a short
timer?
For my understanding: what is "echo 1 > sys/class/scsi_host/host1/issue_lip"?
When we used it after not having waited for nodev_tmo, it didn't cause a
rescan (i.e., the target still had the old wwpn).

BTW: at least once when we disconnected one target and connected the other
without waiting for nodev_tmo, we saw the situation, that the new target was
accessible, while sysfs still showed us the old wwpn.

	Bodo
> 
> -- James
> 
> 
> 
>>Regards
>>Bodo
>>
>>P.S.: Please CC me, I'm not on the list.
>>-
>>To unsubscribe from this list: send the line "unsubscribe 
>>linux-scsi" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
