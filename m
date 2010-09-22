From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] tcm/pscsi: Add proper BIDI-COMMAND passthrough to
 SCSI MidLayer
Date: Wed, 22 Sep 2010 13:35:00 +0200
Message-ID: <4C99E9E4.6040609@panasas.com>
References: <1285135732-8350-1-git-send-email-nab@linux-iscsi.org> <4C99E4BC.5010301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:6128 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947Ab0IVLfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2010 07:35:04 -0400
In-Reply-To: <4C99E4BC.5010301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

On 09/22/2010 01:13 PM, Boaz Harrosh wrote:
> On 09/22/2010 08:08 AM, Nicholas A. Bellinger wrote:

<snip>

>>  	return task->task_sg_num;
> 
> OK Now I'm sure!
> You have completely missed the fact that bidi entails two sg_list(s)
> two sg_num(s) and two io_byte_count(s).
> 
> The use of sg_table will clear that confusion a bit, though I wanted it
> to carry an  io_byte_count as well, but never came to do that.
> 

OK actually you should use scsi_data_buffer better then sg_table. Because
it also has the length. And it even has a resid. Because with bidi-commands
there are two residual counters reported in command-response. You can see
libiscsi for how it handles the bidi residual counters.

Boaz
