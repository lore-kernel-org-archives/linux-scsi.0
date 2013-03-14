From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC 00/11] Add support for iSCSI Extentions for RDMA (ISER)
 target
Date: Thu, 14 Mar 2013 10:17:30 +0200
Message-ID: <5141879A.7060608@mellanox.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:45235 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988Ab3CNIRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 04:17:41 -0400
In-Reply-To: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>

On 08/03/2013 03:45, Nicholas A. Bellinger wrote:
> This series is first RFC for iSCSI Extentions for RDMA (ISER) target
> support with existing iscsi-target TCP based socket code for a future v3.10 merge.
>
> This code is available in git here:
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git iser_target-rfcv1
>
> Ths includes a basic iscsit_transport API that allows different transports
> to reside under a single iscsi-target configfs control plane, using an
> pre-defined network portal attribute to enable a rdma_cm listener on top
> of existing ipoib portals.

Hi Nic,

Here are quick few nits (...) which need to be sorted out for the next 
version, I've picked them from running the patches through checkpatch 
and sparse / gcc warnings checks

  target-pending]# git format-patch -o /tmp/lio-iser-rfc 
7b745c84a9f4ad62db4b67053fbceb5d706451af..
/tmp/lio-iser-rfc/0001-iscsi-target-Add-iscsit_transport-API-template.patch
/tmp/lio-iser-rfc/0002-iscsi-target-Initial-traditional-TCP-conversion-to-i.patch
/tmp/lio-iser-rfc/0003-iscsi-target-Add-iser-target-parameter-keys-setup-du.patch
/tmp/lio-iser-rfc/0004-iscsi-target-Add-per-transport-iscsi_cmd-alloc-free.patch
/tmp/lio-iser-rfc/0005-iscsi-target-Refactor-RX-PDU-logic-export-request-PD.patch
/tmp/lio-iser-rfc/0006-iscsi-target-Refactor-TX-queue-logic-export-response.patch
/tmp/lio-iser-rfc/0007-iscsi-target-Add-iser-network-portal-attribute.patch
/tmp/lio-iser-rfc/0008-iser-target-Add-base-proto-includes.patch
/tmp/lio-iser-rfc/0009-iser-target-Add-logic-for-verbs.patch
/tmp/lio-iser-rfc/0010-iser-target-Add-logic-for-core.patch
/tmp/lio-iser-rfc/0011-iser-target-Add-Makefile-Kconfig.patch

target-pending]# ./scripts/checkpatch.pl --strict /tmp/lio-iser-rfc/* | 
grep total
total: 0 errors, 8 warnings, 0 checks, 142 lines checked
total: 1 errors, 14 warnings, 6 checks, 1097 lines checked
total: 0 errors, 15 warnings, 7 checks, 299 lines checked
total: 0 errors, 0 warnings, 0 checks, 106 lines checked
total: 0 errors, 13 warnings, 4 checks, 795 lines checked
total: 1 errors, 12 warnings, 2 checks, 877 lines checked
total: 0 errors, 5 warnings, 0 checks, 83 lines checked
total: 7 errors, 12 warnings, 1 checks, 170 lines checked
total: 1 errors, 9 warnings, 14 checks, 481 lines checked
total: 1 errors, 39 warnings, 43 checks, 1732 lines checked
total: 0 errors, 0 warnings, 0 checks, 21 lines checked

drivers/infiniband/ulp/isert/isert_core.c:774:1: warning: symbol 
'isert_dump_ib_wc' was not declared. Should it be static?
drivers/infiniband/ulp/isert/isert_verbs.c:341:1: warning: symbol 
'isert_put_conn' was not declared. Should it be static?
drivers/infiniband/ulp/isert/isert_verbs.c:375:1: warning: symbol 
'isert_cma_handler' was not declared. Should it be static?
drivers/infiniband/ulp/isert/isert_verbs.c:416:1: warning: symbol 
'isert_post_recv' was not declared. Should it be static?
drivers/infiniband/ulp/isert/isert_verbs.c:451:1: warning: symbol 
'isert_post_send' was not declared. Should it be static?

drivers/infiniband/ulp/isert/isert_core.c: In function ?isert_rx_do_work?:
drivers/infiniband/ulp/isert/isert_core.c:481: warning: variable ?rc? 
set but not used


Or.
