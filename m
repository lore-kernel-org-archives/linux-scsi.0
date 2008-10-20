From: Chuck Lever <chuck.lever@oracle.com>
Subject: Problems with new block device size reporting
Date: Mon, 20 Oct 2008 17:58:50 -0400
Message-ID: <3F0757B4-6310-4EB7-9E2B-C51101BCC41A@oracle.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:52074 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYJTV65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Oct 2008 17:58:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>

[ Cc'ing myself because I'm not subscribed to linux-scsi ]

Hi James-

I found two problems in 2.6.27:

1.  If CONFIG_LBD is not set on 32-bit platforms, the computation  
added in sd_read_capacity() by commit 7404ad3b computes sz  
incorrectly.  On my system (a Fedora 9 VMware guest with an 8GB disk),  
sz is computed as zero.

2.  The new string helper string_get_size() added by commit 3c9f3681  
goes into an infinite loop if it is passed a "size" of zero.  the "for  
(j=0;" loop never terminates because 0*10 is always less than 1000.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
