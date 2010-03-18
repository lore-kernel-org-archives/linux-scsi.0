From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Thu, 18 Mar 2010 16:02:52 -0500
Message-ID: <4BA294FC.3030400@cs.wisc.edu>
References: <20100317180647.GA25863@serverengines.com> <20100318225808Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59638 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0CRU7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 16:59:25 -0400
In-Reply-To: <20100318225808Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jayamohank@serverengines.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, open-iscsi@googlegroups.com

On 03/18/2010 08:58 AM, FUJITA Tomonori wrote:
>
> - You invent your hardware specific data structure for the simplest
>    operation such as setting IP address.

I think this is what Jay is not trying to do. I think the patch has some 
extra code like the ISCSI_BSG_HST_VENDOR parts that makes it confusing - 
it got me too. The ISCSI_BSG_HST_VENDOR code in be2iscsi looks like it 
is basically disabled (should remove for a formal patch when he sends 
for merging).

It looks like there is a common struct iscsi_bsg_common_format that is 
getting passed around, and then in be2iscsi the driver is using that 
info to make a be2iscsi specific command. So scsi_transport_iscsi / 
ISCSI_SET_IP_ADDR / iscsi_bsg_common_format  gets translated by b2iscsi 
to b2iscsi / OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR / be_modify_ip_addr.

So the approach using a common struct/cmd is ok with me, and if we can 
get a struct format works for everyone (qla4xxx, be2iscsi, cxgb4i) then 
I am fine.
