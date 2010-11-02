From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsis: Move to struct ibmvscsis_vdev usage in	fabric
 configfs handlers
Date: Tue, 02 Nov 2010 08:47:24 -0500
Message-ID: <4CD0166C.5060403@linux.vnet.ibm.com>
References: <1288480434-29670-1-git-send-email-nab@linux-iscsi.org> <20101102060030Z.fujita.tomonori@lab.ntt.co.jp> <1288647462.7708.31.camel@haakon2.linux-iscsi.org> <20101102070638M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:57907 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0KBNrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2010 09:47:18 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id oA2Dh0s9004119
	for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2010 07:43:00 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oA2DlINk156648
	for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2010 07:47:18 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oA2DlGKA013886
	for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2010 07:47:17 -0600
In-Reply-To: <20101102070638M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, lxie@us.ibm.com, rcjenn@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@suse.de, joel.becker@oracle.com

On 11/01/2010 05:15 PM, FUJITA Tomonori wrote:
> On Mon, 01 Nov 2010 14:37:42 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
>> On Tue, 2010-11-02 at 06:05 +0900, FUJITA Tomonori wrote:
>>> On Sat, 30 Oct 2010 16:13:54 -0700
>>> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
>>>
>>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>>
>>>> This patch takes tomo-san original commit 94fdb0196151 and changes a handful
>>>> of important items wrt to the fabric configfs logic.
>>>>
>>>> Firstly, this patch introduces struct ibmvscsis_vdev and converts the
>>>> VIO ibmvscsis_probe() and ibmvscsi_remove() callers to allocate/free
>>>> struct ibmvscsis_vdev instead of the original usage of struct ibmvscsis_tpg
>>>> which is intended to be allocated/freed respectively in ibmvscsis_make_tpg()
>>>> and ibmvscsis_drop_tpg() fabric configfs handlers.
>>>
>>> What happens if an initiator sends a crq command before an user
>>> creates a tpg? Or what happens if an initiator sends a crq command
>>> after removing a tpg?
>>>
>>
>> Hmmm, good point.  So this would require ibmvscsis_queuecommand() to
>> check internal some ibmvscsi_tpg state to determine availability, and
>> reject incoming I/O otherwise.  The other operation would be to just
>> move crq queue creation/release for individual ibmvscsi_vdev into
>> ibmvscsis_make_tpg() and ibmvscsis_drop_tpg().
> 
> You don't need to create/release rcq. I think that enable/disable vio
> interrupts is enough.

Maybe I'm not following the conversation here, but if you just disable vio
interrupts, then any commands sent by a client LPAR would be seen to hang
from the client's perspective. If ibmvscsis doesn't have the CRQ registered,
then firmware will fail client commands with a response indicating the server
is not ready.

Thanks,

Brian


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


