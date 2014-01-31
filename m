From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [LSF/MM TOPIC] Fixing large block devices on 32 bit
Date: Fri, 31 Jan 2014 13:47:18 -0800
Message-ID: <52EC19E6.9010509@intel.com>
References: <1391194978.2172.20.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1391194978.2172.20.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On 01/31/2014 11:02 AM, James Bottomley wrote:
>      3. Increase pgoff_t and the radix tree indexes to u64 for
>         CONFIG_LBDAF.  This will blow out the size of struct page on 32
>         bits by 4 bytes and may have other knock on effects, but at
>         least it will be transparent.

I'm not sure how many acrobatics we want to go through for 32-bit, but...

Between page->mapping and page->index, we have 64 bits of space, which
*should* be plenty to uniquely identify a block.  We could easily add a
second-level lookup somewhere so that we store some cookie for the
address_space instead of a direct pointer.  How many devices would need,
practically?  8 bits worth?
