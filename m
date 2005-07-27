From: randy_dunlap <rdunlap@xenotime.net>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Tue, 26 Jul 2005 20:20:58 -0700
Message-ID: <20050726202058.133382c1.rdunlap@xenotime.net>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	<20050709210824.29a90c5b.rdunlap@xenotime.net>
	<42D12A39.80207@drzeus.cx>
	<20050710093907.3f3c36e4.rdunlap@xenotime.net>
	<42D15968.1080101@drzeus.cx>
	<20050710105635.6d1606e3.rdunlap@xenotime.net>
	<42D17D49.1000007@drzeus.cx>
	<Pine.LNX.4.60.0507132312050.8774@poirot.grange>
	<42E03506.7030707@drzeus.cx>
	<20050721235348.05eace11.rdunlap@xenotime.net>
	<20050722135055.6cb4597d.rdunlap@xenotime.net>
	<42E17451.6090706@drzeus.cx>
	<20050722153651.28d5db51.rdunlap@xenotime.net>
	<42E17772.3020903@drzeus.cx>
	<20050723100945.7d43d063.rdunlap@xenotime.net>
	<42E2933C.4050808@drzeus.cx>
	<20050723152714.4212ba52.rdunlap@xenotime.net>
	<42E2ECF1.8070501@drzeus.cx>
	<20050723184014.49629f9e.rdunlap@xenotime.net>
	<42E39462.3040007@drzeus.cx>
	<20050724100153.3e891484.rdunlap@xenotime.net>
	<42E565FE.4070708@drzeus.cx>
	<20050725203
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chretien.genwebhost.com ([209.59.175.22]:30051 "EHLO
	chretien.genwebhost.com") by vger.kernel.org with ESMTP
	id S261970AbVG0DVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 23:21:10 -0400
In-Reply-To: <42E6A5C3.6070501@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: g.liakhovetski@gmx.de, oliver@neukum.name, linux-scsi@vger.kernel.org

On Tue, 26 Jul 2005 23:06:11 +0200 Pierre Ossman wrote:

> randy_dunlap wrote:
> 
> >
> >The only 2 differences that I can see that would affect this
> >(diff patch-2.6.12.1 vs. patch-2.6.1.2) are:  (cut-n-paste, so
> >has whitespace munging)
> >
> >  
> >
> 
> Neither had any effect. :/

oh drat.  Please test 2.6.12.2 with the following patch segment
backed out (-R, reversed).  I don't see any other patches that could
be the cause.  If this isn't the problem, I would have to begin
to suspect some kind of toolchain problem.

Thanks,
~Randy


diff --git a/include/asm-i386/string.h b/include/asm-i386/string.h
--- a/include/asm-i386/string.h
+++ b/include/asm-i386/string.h
@@ -116,7 +116,8 @@ __asm__ __volatile__(
 	"orb $1,%%al\n"
 	"3:"
 	:"=a" (__res), "=&S" (d0), "=&D" (d1)
-		     :"1" (cs),"2" (ct));
+	:"1" (cs),"2" (ct)
+	:"memory");
 return __res;
 }
 
@@ -138,8 +139,9 @@ __asm__ __volatile__(
 	"3:\tsbbl %%eax,%%eax\n\t"
 	"orb $1,%%al\n"
 	"4:"
-		     :"=a" (__res), "=&S" (d0), "=&D" (d1), "=&c" (d2)
-		     :"1" (cs),"2" (ct),"3" (count));
+	:"=a" (__res), "=&S" (d0), "=&D" (d1), "=&c" (d2)
+	:"1" (cs),"2" (ct),"3" (count)
+	:"memory");
 return __res;
 }
 
@@ -158,7 +160,9 @@ __asm__ __volatile__(
 	"movl $1,%1\n"
 	"2:\tmovl %1,%0\n\t"
 	"decl %0"
-	:"=a" (__res), "=&S" (d0) : "1" (s),"0" (c));
+	:"=a" (__res), "=&S" (d0)
+	:"1" (s),"0" (c)
+	:"memory");
 return __res;
 }
 
@@ -175,7 +179,9 @@ __asm__ __volatile__(
 	"leal -1(%%esi),%0\n"
 	"2:\ttestb %%al,%%al\n\t"
 	"jne 1b"
-	:"=g" (__res), "=&S" (d0), "=&a" (d1) :"0" (0),"1" (s),"2" (c));
+	:"=g" (__res), "=&S" (d0), "=&a" (d1)
+	:"0" (0),"1" (s),"2" (c)
+	:"memory");
 return __res;
 }
 
@@ -189,7 +195,9 @@ __asm__ __volatile__(
 	"scasb\n\t"
 	"notl %0\n\t"
 	"decl %0"
-	:"=c" (__res), "=&D" (d0) :"1" (s),"a" (0), "0" (0xffffffffu));
+	:"=c" (__res), "=&D" (d0)
+	:"1" (s),"a" (0), "0" (0xffffffffu)
+	:"memory");
 return __res;
 }
 
@@ -333,7 +341,9 @@ __asm__ __volatile__(
 	"je 1f\n\t"
 	"movl $1,%0\n"
 	"1:\tdecl %0"
-	:"=D" (__res), "=&c" (d0) : "a" (c),"0" (cs),"1" (count));
+	:"=D" (__res), "=&c" (d0)
+	:"a" (c),"0" (cs),"1" (count)
+	:"memory");
 return __res;
 }
 
@@ -369,7 +379,7 @@ __asm__ __volatile__(
 	"je 2f\n\t"
 	"stosb\n"
 	"2:"
-	: "=&c" (d0), "=&D" (d1)
+	:"=&c" (d0), "=&D" (d1)
 	:"a" (c), "q" (count), "0" (count/4), "1" ((long) s)
 	:"memory");
 return (s);	
@@ -392,7 +402,8 @@ __asm__ __volatile__(
 	"jne 1b\n"
 	"3:\tsubl %2,%0"
 	:"=a" (__res), "=&d" (d0)
-	:"c" (s),"1" (count));
+	:"c" (s),"1" (count)
+	:"memory");
 return __res;
 }
 /* end of additional stuff */
@@ -473,7 +484,8 @@ static inline void * memscan(void * addr
 		"dec %%edi\n"
 		"1:"
 		: "=D" (addr), "=c" (size)
-		: "0" (addr), "1" (size), "a" (c));
+		: "0" (addr), "1" (size), "a" (c)
+		: "memory");
 	return addr;
 }
 
