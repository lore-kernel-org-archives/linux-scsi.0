From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] iscsi-target: Convert iscsi_thread_set usage to
 kthread.h
Date: Wed, 25 Mar 2015 23:45:35 -0700
Message-ID: <1427352335.9176.81.camel@haakon3.risingtidesystems.com>
References: <1426918564-22581-1-git-send-email-nab@daterainc.com>
	 <1426918564-22581-2-git-send-email-nab@daterainc.com>
	 <55100547.2090208@dev.mellanox.co.il> <551192E0.509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45938 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbbCZGph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 02:45:37 -0400
In-Reply-To: <551192E0.509@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Slava Shwartsman <valyushash@gmail.com>

On Tue, 2015-03-24 at 18:37 +0200, Sagi Grimberg wrote:
> On 3/23/2015 2:21 PM, Sagi Grimberg wrote:
> > On 3/21/2015 8:16 AM, Nicholas A. Bellinger wrote:
> >> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>
> >> This patch converts iscsi-target code to use modern kthread.h API
> >> callers for creating RX/TX threads for each new iscsi_conn descriptor,
> >> and releasing associated RX/TX threads during connection shutdown.
> >>
> >> This is done using iscsit_start_kthreads() -> kthread_run() to start
> >> new kthreads from within iscsi_post_login_handler(), and invoking
> >> kthread_stop() from existing iscsit_close_connection() code.
> >>
> >> Also, convert iscsit_logout_post_handler_closesession() code to use
> >> cmpxchg when determing when iscsit_cause_connection_reinstatement()
> >> needs to sleep waiting for completion.
> >
> > I'll run some tests with this.
> 
> Hi Nic,
> 
> I can report that this series (minus patch 3/3 and along with some
> patches I'll send out soon) seems to resolve the list corruption issue
> I've seen.
> 
> Overall the patches look good to me so feel free to include
> patches 1+2 with:
> 
> Tested-by: Sagi Grimberg <sagig@mellanox.com>
> 

Great.  The first two are queued in for-next, and for the moment #1 has
a v3.10+ stable tag as well..

Please let me know if you run into any regressions with these.

Thanks alot Sagi!

--nab

