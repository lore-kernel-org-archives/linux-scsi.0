From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/2] iscsi-target: Fix rx_login_comp hang after login
 failure
Date: Mon, 16 Nov 2015 13:27:56 +0200
Message-ID: <5649BDBC.5080601@dev.mellanox.co.il>
References: <1447546903-15305-1-git-send-email-nab@daterainc.com>
 <1447546903-15305-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35898 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbKPL2C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2015 06:28:02 -0500
Received: by wmww144 with SMTP id w144so105722986wmw.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2015 03:28:00 -0800 (PST)
In-Reply-To: <1447546903-15305-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>



On 15/11/2015 02:21, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch addresses a case where iscsi_target_do_tx_login_io()
> fails sending the last login response PDU, after the RX/TX
> threads have already been started.
>
> The case centers around iscsi_target_rx_thread() not invoking
> allow_signal(SIGINT) before the send_sig(SIGINT, ...) occurs
> from the failure path, resulting in RX thread hanging
> indefinately on iscsi_conn->rx_login_comp.
>
> Note this bug is a regression introduced by:
>
>    commit e54198657b65625085834847ab6271087323ffea
>    Author: Nicholas Bellinger <nab@linux-iscsi.org>
>    Date:   Wed Jul 22 23:14:19 2015 -0700
>
>        iscsi-target: Fix iscsit_start_kthreads failure OOPs
>
> To address this bug, complete ->rx_login_complete for good
> measure in the failure path, and immediately return from
> RX thread context if connection state did not actually reach
> full feature phase (TARG_CONN_STATE_LOGGED_IN).

Hey Nic,

Will it make better sense to start the rx/tx threads after
the login was completed (i.e. the conn is in state
TARG_CONN_STATE_LOGGED_IN) instead?

Sagi.
