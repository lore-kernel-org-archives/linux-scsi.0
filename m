From: Arjan van de Ven <arjan@infradead.org>
Subject: qla2xxx lock ordering question
Date: Wed, 19 Apr 2006 11:22:04 +0200
Message-ID: <1145438524.3085.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:27316 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750817AbWDSJWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 05:22:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: mingo@elte.hu, linux-scsi@vger.kernel.org

Hi,

a question about qla2xxx lock ordering since it trips up with Ingo's
lock depenceny tool:

in qla2x00_mailbox_command() the code first grabs the mbx_reg_lock lock,
then the hardware_lock. So far so good. But then...
it drops the mbx_reg_lock, does stuff, and regrabs the mbx_reg_lock
lock, while keeping the hardware_lock held!

This appears to be an AB-BA deadlock risk since for the second part you
are taking the locks in the wrong order... or am I missing something
here?

Greetings,
   Arjan van de Ven

