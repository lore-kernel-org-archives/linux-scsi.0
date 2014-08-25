From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Debugging scsi abort handling ?
Date: Mon, 25 Aug 2014 12:28:51 +0200
Message-ID: <53FB0FE3.80603@acm.org>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:56183 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbaHYLEy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 07:04:54 -0400
In-Reply-To: <53FAF80D.2070209@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/25/14 10:47, Hans de Goede wrote:
> I want to see how real hardware deals with abort commands (e.g. does it
> only acknowledge the abort, or does it also sends a sense code for
> the actual command).

The SCSI specs define whether a reply should be sent if a SCSI command
has been aborted. From SAM-5: "5.3.1 Status codes [ ... ] TASK ABORTED.
This status shall be returned when a command is aborted by a command or
task management function on another I_T nexus and the Control mode page
TAS bit is set to one (see 5.6)."

"5.6 Aborting commands - A command is aborted when a SCSI device
condition (see 6.3), command, or task management function causes
termination of the command prior to its completion by the device server.
After a command is aborted and TASK ABORTED status, if any, is returned,
the SCSI target device shall send no further requests or responses for
that command."

>From SPC-4: "7.5.8 Control mode page [ ... ] A task aborted status (TAS)
bit set to zero specifies that aborted commands shall be terminated by
the device server without any response to the application client. A TAS
bit set to one specifies that commands aborted by the actions of an I_T
nexus other than the I_T nexus on which the command was received shall
be completed with TASK ABORTED status (see SAM-5)."

Bart.
