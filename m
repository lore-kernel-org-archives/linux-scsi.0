From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: qla4xxx : Driver v5.00.05b4-k - RFC requested!!!
Date: Fri, 03 Mar 2006 11:27:23 +0100
Message-ID: <1141381643.2883.49.camel@laptopd505.fenrus.org>
References: <3679966B84813344B908D418BA3F6A4A06E85C7E@AVEXCH01.qlogic.org>
Reply-To: arjan@infradead.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29835 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751239AbWCCK1Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 05:27:25 -0500
In-Reply-To: <3679966B84813344B908D418BA3F6A4A06E85C7E@AVEXCH01.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-03-02 at 14:52 -0800, Ravi Anand wrote:
> All,
> 
> For the upstream inclusion of qla4xxx driver, following files :


> - Updated driver source (qla4xxx-src-v5.00.05b4-k_submit.tar.bz2)


another thing:

+               set_current_state(TASK_UNINTERRUPTIBLE);
+               schedule_timeout(10);


this is obviously a bug.. for which HZ value is that 10?

I think you really want to use msleep() instead here, which uses
wallclock time units, and does the state setting for you as well.
(and is generally a nicer albeit simpler API than schedule_timeout() )

