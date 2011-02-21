From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: transport_get_lun_for_tmr() failure behavior
Date: Mon, 21 Feb 2011 01:53:44 -0800
Message-ID: <1298282024.26616.79.camel@haakon2.linux-iscsi.org>
References: <AANLkTinA2SMk=6y4Au0BbyS8O=m2P-D7+Y70Cr-gs8R8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42728 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1BUKBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Feb 2011 05:01:25 -0500
In-Reply-To: <AANLkTinA2SMk=6y4Au0BbyS8O=m2P-D7+Y70Cr-gs8R8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-02-15 at 21:02 +0100, Fubo Chen wrote:
> Hi,
> 
> While trying figure out how transport_get_lun_for_tmr() works I
> noticed that flag SCF_SCSI_CDB_EXCEPTION is set if LUN not found but
> that se_cmd->scsi_sense_reason is not set. Is that on purpose ?
> 
> Same remark for transport_new_cmd_failure().
> 

Currently a default TCM_UNSUPPORTED_SCSI_OPCODE for struct
se_cmd->scsi_sense_reason will be set and emulated sense payload built
from within transport_generic_request_failure() for the latter
transport_new_cmd_failure() case for a failed received struct se_cmd
descriptor..

For the transport_get_lun_for_tmr() failure case a failed task
management request will be translated into a fabric specific task
management response following include/target/target_core_tmr.h:enum
tcm_tmrsp_table.

--nab


