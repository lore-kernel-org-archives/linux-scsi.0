From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] fcoe:Fix incorrect use of non wrapper
 version of skb_buff helper function in fcoe_percpu_recieve_thread
Date: Mon, 21 Sep 2015 13:09:28 -0700
Message-ID: <20150921200928.GA29489@straylight.hirudinean.org>
References: <1442787759-13033-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442787759-13033-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 20, 2015 at 06:22:39PM -0400, Nicholas Krause wrote:
> This fixes the incorrect use of the non wrapper version of the
> function skb_dequeue in fcoe_percpu_receive_thread to use the
> wrapper version as we need to protect avoid other users from
> concurrently access on the sk_buff_head tmp used as the link
> list head for this call to skb_queue.

The sk_buff_head tmp is a local reference on the stack, so not accessed
concurrently from anywhere.  It's set with skb_queue_splice_init while
holding the lock for the real fcoe_rx_list, specifically to batch
process without repeatedly taking and dropping the lock.

Nak, flawed reasoning for justification.

- Chris
