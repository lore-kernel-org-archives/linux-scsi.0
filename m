From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] 2.4.21 fix race condition in sg.c
Date: 27 Jun 2003 15:31:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056724288.3172.43.camel@dhcp22.swansea.linux.org.uk>
References: <002901c33cb3$4b262730$e0019d89@cybernetics.com>
	 <1056723054.1825.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:17542
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S264362AbTF0OV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 10:21:57 -0400
In-Reply-To: <1056723054.1825.16.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: tonyb@cybernetics.com, Marcelo Tosatti <marcelo@conectiva.com.br>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dougg@torque.net

On Gwe, 2003-06-27 at 15:10, James Bottomley wrote:
> Memory barriers can be expensive on some architectures, so it's best to
> use them only where necessary.

For cases you just have to force compiler ordering you can use barrier, which
resolves to 

 __asm__ __volatile__("": : :"memory")

ie an empty space that affects memory so causes write backs 

