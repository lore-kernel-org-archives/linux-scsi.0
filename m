From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: the problem about a320raid driver
Date: Tue, 18 Jan 2005 08:28:30 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BA3C428@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:26009 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261293AbVARN2c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 08:28:32 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Richard Cai <richardc@sz.webex.com>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig writes:
On Tue, Jan 18, 2005 at 05:39:03PM +0800, Richard Cai wrote:
>>    I am using intel SE7501WV2 server, with a AIC 7902(A) SCSI control
,
>> a320raid driver. OS is redhat 8.0 , kernel is 2.4.18-14. if I run
lsmod,
>> it showes the a320raid module is right. Now I want to recompile to
>> kernel , but every time when I run the command make install, it will
>> prompt : "No module a320raid found for kernel 2.4.18-14custom " . Who
>> can lead me a right way ? thanks. 
> There's never been an a320raid module in the kernel tree.  Try to find
> out where you got it from and ask them for the driver source.

The driver is from Adaptec, and contains proprietary RAID code, and was
release as a binary only.

You have three options:
1) Risky, recompile using a `standard' RH configuration name (ie: drop
custom) or be willing to do a forced load of the module, ignore the
error or circumvent it, and reuse the distributed a320raid module as-is.
If internal kernel structures change with your custom config, you will
be SOL.
2) Acquire the emd driver in combination with aic79xx. Emd reads the
RAID metadata from the drives. Emd was released by Adaptec (Justin
Gibbs) as reported in the raid list last year and is a public domain
replacement for the a320raid driver.
3) Drop the driver arrays and minimize your data losses, turn off
HostRAID mode on the adapter and use the aic79xx driver. If you need the
arrays, transition to one of dm, md or emd software RAID drivers.

Sincerely -- Mark Salyzyn
