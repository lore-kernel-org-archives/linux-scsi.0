From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Mon, 28 Jul 2008 21:49:05 +0400
Message-ID: <488E0691.8090704@vlnb.net>
References: <488E02DE.5080100@vlnb.net> <20080728174100.GD12762@plap4-2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:35608 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750827AbYG1RtB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 13:49:01 -0400
In-Reply-To: <20080728174100.GD12762@plap4-2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Andrew Vasquez wrote:
> On Mon, 28 Jul 2008, Vladislav Bolkhovitin wrote:
> 
>> This patch fixes race on dpc_thread field of struct scsi_qla_host,
>> which can lead to crash on the module unload.
>>
>> This patch is against 2.6.26
>>
>> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> 
> Vladislav,
> 
> Could you provide some details on the failure you encountered which
> prompted this patch (backtrace/reproduction method)?

Sure. Here is the original report from Gal Rosen:

--------------------------------------------------------------------

This issue occurs when rmmod'ing the qla target then scst modules and
then the qla initiator from a script, constantly, but it is not related
to the target specifically, it happened also when in one shell loading
the qla driver and in other shell rmmod it.

Running the script that rmmod'ing the modules cause panic. All modules
except the qla2xxx were unloaded successfully. The panic occur because
the qla2xxx_wake_dpc() is not protected well. If this function called
from one of the dpc threads or from interrupt, and at the same time some
one unloading the module, then the pointer to the task structure (the
dpc_thread) will be changed to NULL while the wake_up_process() try to
use it.

--------------------------------------------------------------------

Vlad


