From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9775] HOST_MSG_LOOP invalid SCB ff
Date: Fri,  8 Feb 2008 18:52:41 -0800 (PST)
Message-ID: <20080209025241.9B31B11D107@picon.linux-foundation.org>
References: <bug-9775-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58977 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbYBIC4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 21:56:09 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m192r6Id023653
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 18:54:18 -0800
In-Reply-To: <bug-9775-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9775





------- Comment #8 from john@mib-infotech.co.nz  2008-02-08 18:52 -------
Ok, I've spent some time trying different combinations of devices.

Against kernel 2.6.24
T0 is Quantum DLT8000 ID0
T1 is Quantum DLT8000 ID1
MTX     is STK L80  ID 15
Terminators A, B

Channel                         A                       B
                                        T0,T1,MTX,B     Nil                    
                Crash
                                        Nil                     T0,T1,MTX,B    
                Parity Error in Data-in Phase
                                        Nil                     T0,MTX,B       
                Ok, Tar test ok, MTX ok
                                        Nil                     T1,MTX,B       
                Ok, Tar test ok, MTX ok 
-- Both drives work ok          
                                        T1,MTX,B        Nil                    
                Ok   Skipped Tests
                                        T1,MTX,A        Nil                    
                Ok   Skipped Tests
                                        T0,MTX,B        Nil                    
                Crash
                                        T0,MTX,A        Nil                    
                Crash
-- Not the terminator


--Test on two channels
                                        T0,MTX,A        T1,B                   
        Crash
                                        T1,B            T0,MTX,A               
        Parity Error in Data-in Phase                                   

It really doesn't like three devices, on two busses or one.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
