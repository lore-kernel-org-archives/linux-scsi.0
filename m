From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Qlogic qla2xxx driver up for testing
Date: 19 May 2003 19:01:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053388889.1826.50.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B060EC1D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:28420 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262305AbTESXso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 19:48:44 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EC1D@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-05-19 at 18:43, Andrew Vasquez wrote:
> I've just uploaded a new version of the driver to the SF site that
> fixes the 21xx/22xx build problems:
> 
> 	http://marc.theaimsgroup.com/?l=linux-scsi&m=105338567812190&w=2
>  
> > The qla2xxx/Makefile is rather convoluted, and makes it look like
> > building more than one type of driver non-modular may be a problem.
> >

OK, I'll take a look.

> I'm not entirely thrilled with the build process.  Trying to shoehorn
> kbuild into builing three driver binaries was a real mess.  Also, you
> are correct, building more than one driver in a non-modular 
> fashion currently fails -- redefinitions of symbols... (modular builds 
> of the drivers work fine).
> 
> I've read the documentation in kbuild/makefiles.txt, but unfortuantely,
> given the form and structure of the driver sources, I've yet to fashion 
> a simpler build method for the drivers,  any suggestions?

What about simply making it a runtime instead of compile time determined
thing?  None of the #ifdefs looks to occur in a region of code that's
that critical.

If you're worried about firmware size, you could put that into a discard
section.

James

