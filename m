From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Wed, 10 Dec 2003 15:18:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312101518.35450.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:23218 "EHLO
	mtagate6.de.ibm.com") by vger.kernel.org with ESMTP id S262914AbTLJOSv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 09:18:51 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Hi, 

>> while(1) {
>>         scsi_add_device(...)
>>         scsi_remove_device(...);
>> }
>> 
>> It takes only about 40 iterations to reach the out of memory situation.
>> The device that gets added and removed does respond to Inquiry commands.
>> Since I'm not sure what are the pending fixes for the SCSI stack I'm
>> wondering if this is a known bug. 
>
>Sounds there's a scsi_device_put missing somewherein your driver..

Why should I be supposed to issue a scsi_device_put or scsi_device_get in my
device driver?
Actually the scsi_add_device call will call my provided slave_alloc function 
and hands over a struct scsi_device pointer which should be valid until 
scsi_destroy will be called. Which is done when I call scsi_remove_device.
Currently I don't use any scsi_device_get or scsi_device_put functions. 

