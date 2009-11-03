From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Date: Tue, 3 Nov 2009 19:10:06 +0000
Message-ID: <20091103191006.30e8be36@lxorguk.ukuu.org.uk>
References: <1257273488.9427.27.camel@mulgrave.site>
	<20091103105921.160d5599.akpm@linux-foundation.org>
	<20091103190420.GY10555@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754569AbZKCTIe@vger.kernel.org>
In-Reply-To: <20091103190420.GY10555@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 3 Nov 2009 12:04:20 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> 
>  static inline void strsrip_tail(char *str)
>  {
> -	char *x __used;
> -	x = strstrip(str);
> +	char *x = strstrip(str);
> +	BUG_ON(x != str);

That breaks it. It was fine before you did that but now it blows up if
there are leading spaces.
