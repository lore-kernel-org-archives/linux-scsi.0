From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Wed, 19 Apr 2017 22:29:02 -0400
Message-ID: <yq1tw5jq0b5.fsf@oracle.com>
References: <1491850368-7201-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20625 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966806AbdDTC3W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 22:29:22 -0400
In-Reply-To: <1491850368-7201-1-git-send-email-bryantly@linux.vnet.ibm.com>
        (Bryant G. Ly's message of "Mon, 10 Apr 2017 13:52:48 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, Bart.VanAssche@sandisk.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org

"Bryant G. Ly" <bryantly@linux.vnet.ibm.com> writes:

> The driver is sending a response to the aborted task response along
> with LIO sending the tmr response.  ibmvscsis_tgt does not send the
> response to the client until release_cmd time. The reason for this was
> because if we did it at queue_status time, then the client would be
> free to reuse the tag for that command, but we're still using the tag
> until the command is released at release_cmd time, so we chose to
> delay sending the response until then. That then caused this issue,
> because release_cmd is always called, even if queue_status is not.
>
> SCSI spec says that the initiator that sends the abort task TM NEVER
> gets a response to the aborted op and with the current code it will
> send a response. Thus this fix will remove that response if the TAS
> bit is set.

Somebody please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
