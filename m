From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [bug report] target: stack can be smashed
Date: Sat, 13 Aug 2011 22:59:20 -0700
Message-ID: <1313301560.16439.64.camel@haakon2.linux-iscsi.org>
References: <20110809122808.GI7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45945 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab1HNGJE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2011 02:09:04 -0400
In-Reply-To: <20110809122808.GI7659@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>

On Tue, 2011-08-09 at 15:28 +0300, Dan Carpenter wrote:
> Sparse prints the following warnings:
> 
> drivers/target/iscsi/iscsi_target_util.c:1435:32: error: bad constant expression
> drivers/target/iscsi/iscsi_target_util.c:1436:30: error: bad constant expression
> drivers/target/iscsi/iscsi_target_util.c:1563:32: error: bad constant expression
> drivers/target/iscsi/iscsi_target_util.c:1564:30: error: bad constant expression
> 
> Here is the offending code:
>   1430  static int iscsit_do_rx_data(
>   1431          struct iscsi_conn *conn,
>   1432          struct iscsi_data_count *count)
>   1433  {
>   1434          int data = count->data_length, rx_loop = 0, total_rx = 0, iov_len;
>   1435          u32 rx_marker_val[count->ss_marker_count], rx_marker_iov = 0;
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   1436          struct kvec iov[count->ss_iov_count], *iov_p;
>                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   1437          struct msghdr msg;
> 
>   1558  static int iscsit_do_tx_data(
>   1559          struct iscsi_conn *conn,
>   1560          struct iscsi_data_count *count)
>   1561  {
>   1562          int data = count->data_length, total_tx = 0, tx_loop = 0, iov_len;
>   1563          u32 tx_marker_val[count->ss_marker_count], tx_marker_iov = 0;
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   1564          struct kvec iov[count->ss_iov_count], *iov_p;
>                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   1565          struct msghdr msg;
> 
> To me it looks very dangerous (and potentially exploitable) but I
> didn't follow the logic all the way to see what caps are on
> ->ss_marker_count and ->ss_iov_count.
> 

(Also, apologies on the delayed response here)

So the two problematic local scope stack array usage are both zero by
default + only calculated to non zero values when [O,I]FMarker have been
explictly enabled during iSCSI login.  I think it makes sense to remove
these all-together for mainline code, as we really do not expect
initiators to be using markers in the year 2011.  ;)

Removing all of the marker logic in iscsi-target v3.1 is going to be too
much point, considering the amount of changes (and bugs) that have
already gone in.   So at least we will need to always enforce the
negotiation to [O,I]FMarker=No to disable the markers, and drop the
problematic local scope usage above for iscsit_do_tx_data() and
iscsit_do_rx_data() code.

I'll take a look at fixing this up in lio-core-2.6.git shortly, and make
sure this gets queued for v3.1-rc.

Thanks for reporting Dan!

--nab

