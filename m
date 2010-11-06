From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC PATCH] SCSI host lock push-down
Date: Sat, 06 Nov 2010 10:31:05 +0100
Message-ID: <4CD52059.7010503@s5r6.in-berlin.de>
References: <20101105002409.GA21714@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20101105002409.GA21714@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> An alternate arrangement, not presented by this patch, might
> be preferred:  in order to make it clear that queuecommand
> locking has changed, one could s/queuecommand/queuecommand_nl/ in
> Scsi_Host_Template, in order to guarantee that drivers are either
> (a) upgraded or (b) broken at compile time.  Compile-time detection of
> new locking may be desirable, and I'll volunteer to change my patch to
> do that, if community members prefer that route instead of below.

I followed only a fraction of the related discussion.  Thus I wonder why a
renaming of scsi_host_template.queuecommand was not part of these attempts
from the very outset.

Given the choice between compile-time breakage of unconverted drivers and
silent invalidation of potential locking assumptions at runtime, the
preferable way forward is quite clear IMO.

(Since no coexistence period of .queuecommand and .queuecommand_nl or
.unlocked_queuecommand is planned, how about you rename it to .queue_command?
Follows Linux naming conventions more closely.)
-- 
Stefan Richter
-=====-==-=- =-== --==-
http://arcgraph.de/sr/
