From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ATA Write Error and Time-out Notification in User Space
Date: Tue, 03 Jan 2006 21:48:04 +0000
Message-ID: <1136324884.22598.51.camel@localhost.localdomain>
References: <BAY101-F32BC19A49EC86F6FED361BDF2C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <BAY101-F32BC19A49EC86F6FED361BDF2C0@phx.gbl>
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: raw@dslr.net, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Maw, 2006-01-03 at 13:27 -0600, John Treubig wrote:
> I receive this as great news, only I don't know where the -mm tree is 
> located to see if I can get the patch or fix!  Can you give me a few 
> pointers?!

The -mm patches live on kernel.org in pub/linux/kernel/people/akpm/

The patch you want is the one to drivers/ide/ide-io.c although be aware
it will make non PCI ATA controllers crash on errors if applied. The
"right" fix for this is probably to have a hwif->flush_data() function
that defaults to try_to_flush_leftover_data() so that the knowledge
involved is not hacked into the ide core but kept in the driver.


Alan

