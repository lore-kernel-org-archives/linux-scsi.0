From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Fixup KERN_INFO in tmscsim.c
Date: Fri, 15 Aug 2008 22:17:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808152202440.7852@axis700.grange>
References: <20080815121045.48ca37e4@sauron.linicks.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761260AbYHOUR0@vger.kernel.org>
In-Reply-To: <20080815121045.48ca37e4@sauron.linicks.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Warne <nick@ukfsn.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 15 Aug 2008, Nick Warne wrote:

> Setting up my new AMD64 I noticed a curious one liner in syslogs:

Wow, are you sure you need the tmscsim driver on your new amd64 system?:-)

> ^Iwith "disable_clustering=1" and report to maintainers

The message priority is indeed missing in the second line, but it has 
nothing to do with the "^I" in your log. I do not know why your syslogd / 
klogd converts a TAB to "^I". But if it is a problem, I think, the correct 
fix would be something like

-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
-		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
+		printk(KERN_INFO "       with \"disable_clustering=1\" and report to maintainers\n");

Or maybe just remove that printk altogether - it has been there for almost 
2 years now, and I haven't heard a single complaint, but on the other 
hand, maybe you are the first, who at least loaded this driver since 2 
years:-)

Ok, taking into account that this driver is hardly used, I would keep this 
warning in case someone does get a problem.

So, please, redo as above, create with "-p1" format, fix your Sob line

> Signed off by: "Nick Warne" <nick@ukfsn.org>

which has to be

Signed-off-by: Nick Warne <nick@ukfsn.org>

and send the patch inline,

Thanks
Guennadi
---
Guennadi Liakhovetski
