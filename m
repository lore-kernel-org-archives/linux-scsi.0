From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Tue, 12 Nov 2013 17:51:09 -0800
Message-ID: <1384307469.12281.118.camel@haakon3.risingtidesystems.com>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com>
	 <1384204653.12281.7.camel@haakon3.risingtidesystems.com>
	 <1384216960.12281.24.camel@haakon3.risingtidesystems.com>
	 <1384217317.12281.26.camel@haakon3.risingtidesystems.com>
	 <1384219874.12281.42.camel@haakon3.risingtidesystems.com>
	 <B9FFC16A-0592-498D-A7C3-7ABB3EFA61FD@cs.wisc.edu>
	 <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu>
	 <1384230893.12281.72.camel@haakon3.risingtidesystems.com>
	 <52824B3C.10203@cs.wisc.edu>
	 <697D97E420EE024FB7451B574CD4991BCA064F17@NTXBOIMBX05.micron.com>
	 <1384290948.12281.91.camel@haakon3.risingtidesystems.com>
	 <697D97E420EE024FB7451B574CD4991BCA0651A5@NTXBOIMBX05.micron.com>
	 <1384294477.12281.105.camel@haakon3.risingtidesystems.com>
	  <697D97E420EE024FB7451B574CD4991BCA065243@NTXBOIMBX05.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36804 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KMBvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 20:51:11 -0500
In-Reply-To: <697D97E420EE024FB7451B574CD4991BCA065243@NTXBOIMBX05.micron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moussa Ba (moussaba)" <moussaba@micron.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2013-11-12 at 23:03 +0000, Moussa Ba (moussaba) wrote:
> Your latest patch seems to have addressed the problem, I have not been
> able to reproduce it post patch and can readily reproduce it with the
> mainline 3.12 kernel. I will run a longer test tonight, but this seems
> to have done it.
> 

Excellent.  

Ok, so in the end this was bug due to a misinterpretation of how
mutex_trylock() works..

I was originally under the assumption that mutex_trylock() was returning
zero upon contention when cmdsn_mutex was already held by the same
process (as can happen in the iscsi_execute_cmd() exception response
path), and not from a different process (as expected between normal
session RX/TX process contexts)..

Simply avoiding the direct ib_isert callback in lio_queue_status() for
the special iscsi_execute_cmd() exception cases allows the problematic
mutex_trylock() usage in iscsit_increment_maxcmdsn() to go away
entirely.

I'll put these into proper patch series shortly.

Thanks again,

--nab

