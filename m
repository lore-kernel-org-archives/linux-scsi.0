From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Sun, 09 Sep 2012 16:39:06 -0400
Message-ID: <504CFE6A.6020403@pobox.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com> <20120703090441.GA4804@gmail.com> <4FF351F8.1000003@msgid.tls.msk.ru> <20120704024715.GA17095@gmail.com> <4FF3E478.50609@msgid.tls.msk.ru> <20120704070604.GA17769@gmail.com> <CA+6av4mdQ3daHHakRDCmHR_zMfcA_cAoabSuwBrcfjpYgUcXyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA+6av4mdQ3daHHakRDCmHR_zMfcA_cAoabSuwBrcfjpYgUcXyg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Arvydas Sidorenko <asido4@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On 09/09/2012 04:34 PM, Arvydas Sidorenko wrote:
>> Meanwhile there already has a number of SATA disks that have supported
>> this feature.  So I think maybe we can enable it.
>>
>> Regards,
>> Zheng
>
> Blindly enabling FUA by default in my opinion is not a good idea at all.
> I believe the focus should be on detecting FUA support on the device
> instead, which the kernel at this point cannot reliably do (is it possible?).

Premature assumptions.  It is entirely possible that FUA is detected 
accurately, but the software is missing a flush somewhere that FUA 
requires, if disks are to be used in FUA mode.

The filesystem and the block layer must properly generate and order 
their I/Os based on the FUA enablement bits that appear in the block 
layer after libata discovers the SATA FUA feature.

	Jeff




