From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.4.21 fix race condition in sg.c
Date: 27 Jun 2003 09:47:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056725222.2099.21.camel@mulgrave>
References: <002901c33cb3$4b262730$e0019d89@cybernetics.com>
	<1056723054.1825.16.camel@mulgrave>
	<1056724288.3172.43.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:61190 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264389AbTF0OdM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 10:33:12 -0400
In-Reply-To: <1056724288.3172.43.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tonyb@cybernetics.com, Marcelo Tosatti <marcelo@conectiva.com.br>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dougg@torque.net

On Fri, 2003-06-27 at 09:31, Alan Cox wrote:
> For cases you just have to force compiler ordering you can use barrier, which
> resolves to 
> 
>  __asm__ __volatile__("": : :"memory")
> 
> ie an empty space that affects memory so causes write backs 

Right.  The code in question is the only statement between an if block
and a function call, thus I believe it's safe from gcc reordering, so I
was assuming the intent was externally visible ordering (which can be
the expensive one).

James


