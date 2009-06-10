From: christophe.varoqui@free.fr
Subject: do Symmetrix multipath-tools defaults need update ? or
 scsi-to-blk errors management ?
Date: Wed, 10 Jun 2009 23:49:59 +0200 (CEST)
Message-ID: <1766094670.1725191244670599365.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <2113818871.1724831244670374246.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2113818871.1724831244670374246.JavaMail.root@zimbra16-e3.priv.proxad.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Levy_Jerome@emc.com
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jerome,

EMC recently asked my/one-of-your client to active "queue_if_no_path" on Symmetrix logical units, which is not the current default setting in the upstream multipath-tools package.

I'd like to know if you intent on submitting a patch to change the default setting accordingly, or if you'd rather let the no-queueing default unchanged and work on fixing the root cause of this issue.

::: Background information, root cause :::

The Symmetrix array proved to return scsi errors io to submitters in certains circumstances (I was told of errors on R1+R2 network link). The linux kernel lacking finesse in the SCSI->DM error reporting ends-up invalidating in turn each path of the multipath before the multipathd daemon gets a chance to revalidate. "queue_if_no_path" being disabled, the io errors ends up in the FS layer and in the userspace submitter.

::: error log on a 2.6.9 (rhel 4.7) kernel :::

SCSI error : <h b t l> return code 0x8000002
current sday: sense key Aborted Command
Additional sense: Internal target failure
end_request: I/O error, dev sday, sector XXXXX
device-mapper: dm-multipath: Failing path 67:32.

::: unfortunate side effect of queue_if_no_path :::

Activating "queue_if_no_path" is certainly an effecient work-around for this kind of short-lived retriable errors, but this feature compromises data-protection on clusters relying on persistent reservation to fence ios from passive nodes. Ironically, the reason is quite similar : SCSI return codes for reservation conflicts also end up invalidating each path of a multipath, and worse, the io causing the conflict gets queued ! and retried ! until the poor active drops its reservation, unleashing data-corrupting ios from passive node queues on the logical unit.

::: error log on a 2.6.29.x kernel for a reservation conflict :::

sd h:b:t:l: reservation conflict
sd h:b:t:l: [sdu] Unhandled error code
sd h:b:t:l: [sdu] Result: hostbyte=DID_OK driver_byte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdu, sector XXXXX
device-mapper: dm-multipath: Failing path 65:64.

::: persistent reservation + queue_if_no_path, possible solution ? :::

Seems to me scsi_lib.c::scsi_io_completion() should be able to cancel a reservation conflicting io and signal blk_end_request() with no error reported.


Please comment.

Best regards,
cvaroqui
