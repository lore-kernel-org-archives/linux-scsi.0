From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 09/10] isci/core: base state machine and memory descriptors
Date: Thu, 10 Mar 2011 02:55:06 -0800
Message-ID: <20110310105506.6485.77370.stgit@localhost6.localdomain6>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32521 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1CJKxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 05:53:50 -0500
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Generic state machine implementation, and the memory descriptor
interface for the lldd to pass buffers to the core.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .../isci/core/sci_base_memory_descriptor_list.c    |  159 +++
 .../isci/core/sci_base_memory_descriptor_list.h    |  153 +++
 drivers/scsi/isci/core/sci_base_state.h            |   90 ++
 drivers/scsi/isci/core/sci_base_state_machine.c    |  182 ++++
 drivers/scsi/isci/core/sci_base_state_machine.h    |  141 +++
 .../scsi/isci/core/sci_memory_descriptor_list.h    |  168 ++++
 drivers/scsi/isci/core/sci_object.h                |   98 ++
 drivers/scsi/isci/core/scu_completion_codes.h      |  283 ++++++
 drivers/scsi/isci/core/scu_constants.h             |  151 +++
 drivers/scsi/isci/core/scu_event_codes.h           |  336 +++++++
 drivers/scsi/isci/core/scu_task_context.h          |  942 ++++++++++++++++++++
 drivers/scsi/isci/core/scu_viit_data.h             |  178 ++++
 12 files changed, 2881 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/core/sci_base_memory_descriptor_list.c
 create mode 100644 drivers/scsi/isci/core/sci_base_memory_descriptor_list.h
 create mode 100644 drivers/scsi/isci/core/sci_base_state.h
 create mode 100644 drivers/scsi/isci/core/sci_base_state_machine.c
 create mode 100644 drivers/scsi/isci/core/sci_base_state_machine.h
 create mode 100644 drivers/scsi/isci/core/sci_memory_descriptor_list.h
 create mode 100644 drivers/scsi/isci/core/sci_object.h
 create mode 100644 drivers/scsi/isci/core/scu_completion_codes.h
 create mode 100644 drivers/scsi/isci/core/scu_constants.h
 create mode 100644 drivers/scsi/isci/core/scu_event_codes.h
 create mode 100644 drivers/scsi/isci/core/scu_task_context.h
 create mode 100644 drivers/scsi/isci/core/scu_viit_data.h

diff --git a/drivers/scsi/isci/core/sci_base_memory_descriptor_list.c b/drivers/scsi/isci/core/sci_base_memory_descriptor_list.c
new file mode 100644
index 0000000..2d785b5
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_base_memory_descriptor_list.c
@@ -0,0 +1,159 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/**
+ * This file contains the base implementation for the memory descriptor list.
+ *    This is currently comprised of MDL iterator methods.
+ *
+ *
+ */
+
+#include "sci_environment.h"
+#include "sci_base_memory_descriptor_list.h"
+
+/*
+ * ******************************************************************************
+ * * P U B L I C   M E T H O D S
+ * ****************************************************************************** */
+
+void sci_mdl_first_entry(
+	struct sci_base_memory_descriptor_list *base_mdl)
+{
+	base_mdl->next_index = 0;
+
+	/*
+	 * If this MDL is managing another MDL, then recursively rewind that MDL
+	 * object as well. */
+	if (base_mdl->next_mdl != NULL)
+		sci_mdl_first_entry(base_mdl->next_mdl);
+}
+
+
+void sci_mdl_next_entry(
+	struct sci_base_memory_descriptor_list *base_mdl)
+{
+	/*
+	 * If there is at least one more entry left in the array, then change
+	 * the next pointer to it. */
+	if (base_mdl->next_index < base_mdl->length)
+		base_mdl->next_index++;
+	else if (base_mdl->next_index == base_mdl->length) {
+		/*
+		 * This MDL has exhausted it's set of entries.  If this MDL is managing
+		 * another MDL, then start iterating through that MDL. */
+		if (base_mdl->next_mdl != NULL)
+			sci_mdl_next_entry(base_mdl->next_mdl);
+	}
+}
+
+
+struct sci_physical_memory_descriptor *sci_mdl_get_current_entry(
+	struct sci_base_memory_descriptor_list *base_mdl)
+{
+	if (base_mdl->next_index < base_mdl->length)
+		return &base_mdl->mde_array[base_mdl->next_index];
+	else if (base_mdl->next_index == base_mdl->length) {
+		/*
+		 * This MDL has exhausted it's set of entries.  If this MDL is managing
+		 * another MDL, then return it's current entry. */
+		if (base_mdl->next_mdl != NULL)
+			return sci_mdl_get_current_entry(base_mdl->next_mdl);
+	}
+
+	return NULL;
+}
+
+/*
+ * ******************************************************************************
+ * * P R O T E C T E D   M E T H O D S
+ * ****************************************************************************** */
+
+void sci_base_mdl_construct(
+	struct sci_base_memory_descriptor_list *mdl,
+	struct sci_physical_memory_descriptor *mde_array,
+	u32 mde_array_length,
+	struct sci_base_memory_descriptor_list *next_mdl)
+{
+	mdl->length     = mde_array_length;
+	mdl->mde_array  = mde_array;
+	mdl->next_index = 0;
+	mdl->next_mdl   = next_mdl;
+}
+
+/* --------------------------------------------------------------------------- */
+
+bool sci_base_mde_is_valid(
+	struct sci_physical_memory_descriptor *mde,
+	u32 alignment,
+	u32 size,
+	u16 attributes)
+{
+	/* Only need the lower 32 bits to ensure alignment is met. */
+	u32 physical_address = lower_32_bits(mde->physical_address);
+
+	if (
+		((((unsigned long)mde->virtual_address) & (alignment - 1)) != 0)
+		|| ((physical_address & (alignment - 1)) != 0)
+		|| (mde->constant_memory_alignment != alignment)
+		|| (mde->constant_memory_size != size)
+		|| (mde->virtual_address == NULL)
+		|| (mde->constant_memory_attributes != attributes)
+		) {
+		return false;
+	}
+
+	return true;
+}
+
diff --git a/drivers/scsi/isci/core/sci_base_memory_descriptor_list.h b/drivers/scsi/isci/core/sci_base_memory_descriptor_list.h
new file mode 100644
index 0000000..b58d4e8
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_base_memory_descriptor_list.h
@@ -0,0 +1,153 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCI_BASE_MEMORY_DESCRIPTOR_LIST_H_
+#define _SCI_BASE_MEMORY_DESCRIPTOR_LIST_H_
+
+/**
+ * This file contains the protected interface structures, constants and
+ *    interface methods for the struct sci_base_memory_descriptor_list object.
+ *
+ *
+ */
+
+
+#include "sci_memory_descriptor_list.h"
+
+
+/**
+ * struct sci_base_memory_descriptor_list - This structure contains all of the
+ *    fields necessary to implement a simple stack for managing the list of
+ *    available controller indices.
+ *
+ *
+ */
+struct sci_base_memory_descriptor_list {
+	/**
+	 * This field indicates the length of the memory descriptor entry array.
+	 */
+	u32 length;
+
+	/**
+	 * This field is utilized to provide iterator pattern functionality.
+	 * It indicates the index of the next memory descriptor in the iteration.
+	 */
+	u32 next_index;
+
+	/**
+	 * This field will point to the list of memory descriptors.
+	 */
+	struct sci_physical_memory_descriptor *mde_array;
+
+	/**
+	 * This field simply allows a user to chain memory descriptor lists
+	 * together if desired.  This field will be initialized to NULL.
+	 */
+	struct sci_base_memory_descriptor_list *next_mdl;
+
+};
+
+/**
+ * sci_base_mdl_construct() - This method is invoked to construct an memory
+ *    descriptor list. It initializes the fields of the MDL.
+ * @mdl: This parameter specifies the memory descriptor list to be constructed.
+ * @mde_array: This parameter specifies the array of memory descriptor entries
+ *    to be managed by this list.
+ * @mde_array_length: This parameter specifies the size of the array of entries.
+ * @next_mdl: This parameter specifies a subsequent MDL object to be managed by
+ *    this MDL object.
+ *
+ * none.
+ */
+void sci_base_mdl_construct(
+	struct sci_base_memory_descriptor_list *mdl,
+	struct sci_physical_memory_descriptor *mde_array,
+	u32 mde_array_length,
+	struct sci_base_memory_descriptor_list *next_mdl);
+
+/**
+ * sci_base_mde_construct() -
+ *
+ * This macro constructs an memory descriptor entry with the given alignment
+ * and size
+ */
+#define sci_base_mde_construct(mde, alignment, size, attributes) \
+	{ \
+		(mde)->constant_memory_alignment  = (alignment); \
+		(mde)->constant_memory_size       = (size); \
+		(mde)->constant_memory_attributes = (attributes); \
+	}
+
+/**
+ * sci_base_mde_is_valid() - This method validates that the memory descriptor
+ *    is correctly filled out by the SCI User
+ * @mde: This parameter is the mde entry to validate
+ * @alignment: This parameter specifies the expected alignment of the memory
+ *    for the mde.
+ * @size: This parameter specifies the memory size expected for the mde its
+ *    value should not have been changed by the SCI User.
+ * @attributes: This parameter specifies the attributes for the memory
+ *    descriptor provided.
+ *
+ * bool This method returns an indication as to whether the supplied MDE is
+ * valid or not. true The MDE is valid. false The MDE is not valid.
+ */
+bool sci_base_mde_is_valid(
+	struct sci_physical_memory_descriptor *mde,
+	u32 alignment,
+	u32 size,
+	u16 attributes);
+
+#endif /* _SCI_BASE_MEMORY_DESCRIPTOR_LIST_H_ */
diff --git a/drivers/scsi/isci/core/sci_base_state.h b/drivers/scsi/isci/core/sci_base_state.h
new file mode 100644
index 0000000..d6b9c1a
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_base_state.h
@@ -0,0 +1,90 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCI_BASE_STATE_H_
+#define _SCI_BASE_STATE_H_
+
+#include "sci_object.h"
+
+typedef void (*SCI_BASE_STATE_HANDLER_T)(
+	void
+	);
+
+typedef void (*SCI_STATE_TRANSITION_T)(
+	struct sci_base_object *base_object
+	);
+
+/**
+ * struct sci_base_state - The base state object abstracts the fields common to
+ *    all state objects defined in SCI.
+ *
+ *
+ */
+struct sci_base_state {
+	/**
+	 * This field is a function pointer that defines the method to be
+	 * invoked when the state is entered.
+	 */
+	SCI_STATE_TRANSITION_T enter_state;
+
+	/**
+	 * This field is a function pointer that defines the method to be
+	 * invoked when the state is exited.
+	 */
+	SCI_STATE_TRANSITION_T exit_state;
+
+};
+
+#endif /* _SCI_BASE_STATE_H_ */
diff --git a/drivers/scsi/isci/core/sci_base_state_machine.c b/drivers/scsi/isci/core/sci_base_state_machine.c
new file mode 100644
index 0000000..5b1e8da
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_base_state_machine.c
@@ -0,0 +1,182 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/**
+ * This file contains all of the functionality common to all state machine
+ *    object implementations.
+ *
+ *
+ */
+
+#include "sci_base_state_machine.h"
+
+static void sci_state_machine_exit_state(struct sci_base_state_machine *sm)
+{
+	u32 state = sm->current_state_id;
+	SCI_STATE_TRANSITION_T exit = sm->state_table[state].exit_state;
+
+	if (exit)
+		exit(sm->state_machine_owner);
+}
+
+static void sci_state_machine_enter_state(struct sci_base_state_machine *sm)
+{
+	u32 state = sm->current_state_id;
+	SCI_STATE_TRANSITION_T enter = sm->state_table[state].enter_state;
+
+	if (enter)
+		enter(sm->state_machine_owner);
+}
+
+/*
+ * ******************************************************************************
+ * * P R O T E C T E D    M E T H O D S
+ * ****************************************************************************** */
+
+/**
+ * This method will set the initial state and state table for the state
+ *    machine. The caller should follow this request with the initialize
+ *    request to cause the state machine to start.
+ * @sm: This parameter provides the state machine object to be
+ *    constructed.
+ * @state_machine_owner: This parameter indicates the object that is owns the
+ *    state machine being constructed.
+ * @state_table: This parameter specifies the table of state objects that is
+ *    managed by this state machine.
+ * @initial_state: This parameter specifies the value of the initial state for
+ *    this state machine.
+ *
+ */
+void sci_base_state_machine_construct(struct sci_base_state_machine *sm,
+				      struct sci_base_object *owner,
+				      const struct sci_base_state *state_table,
+				      u32 initial_state)
+{
+	sm->state_machine_owner = owner;
+	sm->initial_state_id    = initial_state;
+	sm->previous_state_id   = initial_state;
+	sm->current_state_id    = initial_state;
+	sm->state_table         = state_table;
+}
+
+/**
+ * This method will cause the state machine to enter the initial state.
+ * @sm: This parameter specifies the state machine that is to
+ *    be started.
+ *
+ * sci_base_state_machine_construct() for how to set the initial state none
+ */
+void sci_base_state_machine_start(struct sci_base_state_machine *sm)
+{
+	sm->current_state_id = sm->initial_state_id;
+#if defined(SCI_BASE_ENABLE_SUBJECT_NOTIFICATION)
+	sci_base_subject_notify(&sm->parent);
+#endif
+	sci_state_machine_enter_state(sm);
+}
+
+/**
+ * This method will cause the state machine to exit it's current state only.
+ * @sm: This parameter specifies the state machine that is to
+ *    be stopped.
+ *
+ */
+void sci_base_state_machine_stop(
+	struct sci_base_state_machine *sm)
+{
+	sci_state_machine_exit_state(sm);
+#if defined(SCI_BASE_ENABLE_SUBJECT_NOTIFICATION)
+	sci_base_subject_notify(&sm->parent);
+#endif
+}
+
+/**
+ * This method performs an update to the current state of the state machine.
+ * @sm: This parameter specifies the state machine for which
+ *    the caller wishes to perform a state change.
+ * @next_state: This parameter specifies the new state for the state machine.
+ *
+ */
+void sci_base_state_machine_change_state(
+	struct sci_base_state_machine *sm,
+	u32 next_state)
+{
+	sci_state_machine_exit_state(sm);
+
+	sm->previous_state_id = sm->current_state_id;
+	sm->current_state_id = next_state;
+
+#if defined(SCI_BASE_ENABLE_SUBJECT_NOTIFICATION)
+	/* Notify of the state change prior to entering the state. */
+	sci_base_subject_notify(&sm->parent);
+#endif
+
+	sci_state_machine_enter_state(sm);
+}
+
+/**
+ * This method simply returns the current state of the state machine to the
+ *    caller.
+ * @sm: This parameter specifies the state machine for which to
+ *    retrieve the current state.
+ *
+ * This method returns a u32 value indicating the current state for the
+ * supplied state machine.
+ */
+u32 sci_base_state_machine_get_state(struct sci_base_state_machine *sm)
+{
+	return sm->current_state_id;
+}
+
diff --git a/drivers/scsi/isci/core/sci_base_state_machine.h b/drivers/scsi/isci/core/sci_base_state_machine.h
new file mode 100644
index 0000000..13f6ee8
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_base_state_machine.h
@@ -0,0 +1,141 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCI_BASE_STATE_MACHINE_H_
+#define _SCI_BASE_STATE_MACHINE_H_
+
+#include <linux/string.h>
+
+/**
+ * This file contains all structures, constants, or method declarations common
+ *    to all state machines defined in SCI.
+ *
+ *
+ */
+
+
+#include "sci_base_state.h"
+
+
+/**
+ * SET_STATE_HANDLER() -
+ *
+ * This macro simply provides simplified retrieval of an objects state handler.
+ */
+#define SET_STATE_HANDLER(object, table, state)	\
+	(object)->state_handlers = &(table)[(state)]
+
+/**
+ * struct sci_base_state_machine - This structure defines the fields common to
+ *    all state machines.
+ *
+ *
+ */
+struct sci_base_state_machine {
+	/**
+	 * This field points to the start of the state machine's state table.
+	 */
+	const struct sci_base_state *state_table;
+
+	/**
+	 * This field points to the object to which this state machine is
+	 * associated.  It serves as a cookie to be provided to the state
+	 * enter/exit methods.
+	 */
+	struct sci_base_object *state_machine_owner;
+
+	/**
+	 * This field simply indicates the state value for the state machine's
+	 * initial state.
+	 */
+	u32 initial_state_id;
+
+	/**
+	 * This field indicates the current state of the state machine.
+	 */
+	u32 current_state_id;
+
+	/**
+	 * This field indicates the previous state of the state machine.
+	 */
+	u32 previous_state_id;
+
+};
+
+/*
+ * ******************************************************************************
+ * * P R O T E C T E D    M E T H O D S
+ * ****************************************************************************** */
+
+void sci_base_state_machine_construct(
+	struct sci_base_state_machine *this_state_machine,
+	struct sci_base_object *state_machine_owner,
+	const struct sci_base_state *state_table,
+	u32 initial_state);
+
+void sci_base_state_machine_start(
+	struct sci_base_state_machine *this_state_machine);
+
+void sci_base_state_machine_stop(
+	struct sci_base_state_machine *this_state_machine);
+
+void sci_base_state_machine_change_state(
+	struct sci_base_state_machine *this_state_machine,
+	u32 next_state);
+
+u32 sci_base_state_machine_get_state(
+	struct sci_base_state_machine *this_state_machine);
+
+#endif /* _SCI_BASE_STATE_MACHINE_H_ */
diff --git a/drivers/scsi/isci/core/sci_memory_descriptor_list.h b/drivers/scsi/isci/core/sci_memory_descriptor_list.h
new file mode 100644
index 0000000..a039998
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_memory_descriptor_list.h
@@ -0,0 +1,168 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCI_MEMORY_DESCRIPTOR_LIST_H_
+#define _SCI_MEMORY_DESCRIPTOR_LIST_H_
+
+/**
+ * This file contains all of the basic data types utilized by an SCI user or
+ *    implementor.
+ *
+ *
+ */
+
+
+
+struct sci_base_memory_descriptor_list;
+
+/**
+ *
+ *
+ * SCI_MDE_ATTRIBUTES These constants depict memory attributes for the Memory
+ * Descriptor Entries (MDEs) contained in the MDL.
+ */
+#define SCI_MDE_ATTRIBUTE_CACHEABLE              0x0001
+#define SCI_MDE_ATTRIBUTE_PHYSICALLY_CONTIGUOUS  0x0002
+
+/**
+ * struct sci_physical_memory_descriptor - This structure defines a description
+ *    of a memory location for the SCI implementation.
+ *
+ *
+ */
+struct sci_physical_memory_descriptor {
+	/**
+	 * This field contains the virtual address associated with this descriptor
+	 * element. This field shall be zero when the descriptor is retrieved from
+	 * the SCI implementation.  The user shall set this field prior
+	 * sci_controller_start()
+	 */
+	void *virtual_address;
+
+	/**
+	 * This field contains the physical address associated with this desciptor
+	 * element. This field shall be zero when the descriptor is retrieved from
+	 * the SCI implementation.  The user shall set this field prior
+	 * sci_controller_start()
+	 */
+	dma_addr_t physical_address;
+
+	/**
+	 * This field contains the size requirement for this memory descriptor.
+	 * A value of zero for this field indicates the end of the descriptor
+	 * list.  The value should be treated as read only for an SCI user.
+	 */
+	u32 constant_memory_size;
+
+	/**
+	 * This field contains the alignment requirement for this memory
+	 * descriptor.  A value of zero for this field indicates the end of the
+	 * descriptor list.  All other values indicate the number of bytes to
+	 * achieve the necessary alignment.  The value should be treated as
+	 * read only for an SCI user.
+	 */
+	u32 constant_memory_alignment;
+
+	/**
+	 * This field contains an indication regarding the desired memory
+	 * attributes for this memory descriptor entry.
+	 * Notes:
+	 * - If the cacheable attribute is set, the user can allocate
+	 *   memory that is backed by cache for better performance. It
+	 *   is not required that the memory be backed by cache.
+	 * - If the physically contiguous attribute is set, then the
+	 *   entire memory must be physically contiguous across all
+	 *   page boundaries.
+	 */
+	u16 constant_memory_attributes;
+
+};
+
+/**
+ * sci_mdl_first_entry() - This method simply rewinds the MDL iterator back to
+ *    the first memory descriptor entry in the list.
+ * @mdl: This parameter specifies the memory descriptor list that is to be
+ *    rewound.
+ *
+ */
+void sci_mdl_first_entry(
+	struct sci_base_memory_descriptor_list *mdl);
+
+/**
+ * sci_mdl_next_entry() - This method simply updates the "current" pointer to
+ *    the next sequential memory descriptor.
+ * @mdl: This parameter specifies the memory descriptor list for which to
+ *    return the next memory descriptor entry in the list.
+ *
+ * none.
+ */
+void sci_mdl_next_entry(
+	struct sci_base_memory_descriptor_list *mdl);
+
+/**
+ * sci_mdl_get_current_entry() - This method simply returns the current memory
+ *    descriptor entry.
+ * @mdl: This parameter specifies the memory descriptor list for which to
+ *    return the current memory descriptor entry.
+ *
+ * This method returns a pointer to the current physical memory descriptor in
+ * the MDL. NULL This value is returned if there are no descriptors in the list.
+ */
+struct sci_physical_memory_descriptor *sci_mdl_get_current_entry(
+	struct sci_base_memory_descriptor_list *mdl);
+
+
+#endif  /* _SCI_MEMORY_DESCRIPTOR_LIST_H_ */
+
diff --git a/drivers/scsi/isci/core/sci_object.h b/drivers/scsi/isci/core/sci_object.h
new file mode 100644
index 0000000..801b01b
--- /dev/null
+++ b/drivers/scsi/isci/core/sci_object.h
@@ -0,0 +1,98 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCI_OBJECT_H_
+#define _SCI_OBJECT_H_
+
+/**
+ * This file contains all of the method and constants associated with the SCI
+ *    base object.  The SCI base object is the class from which all other
+ *    objects derive in the Storage Controller Interface.
+ *
+ *
+ */
+
+
+#include "sci_status.h"
+
+/**
+ * struct sci_base_object - all core objects must include this as their
+ *     first member to permit the casting below
+ *
+ * TODO: unwind this assumption, convert these routines and callers to pass a struct
+ * sci_base_object pointer without casting, or convert 'private' to the
+ * expected type per-object
+ *
+ */
+struct sci_base_object {
+	void *private;
+};
+
+static inline void *sci_object_get_association(void *obj)
+{
+	struct sci_base_object *base = obj;
+
+	return base->private;
+}
+
+static inline void sci_object_set_association(void *obj, void *private)
+{
+	struct sci_base_object *base = obj;
+
+	base->private = private;
+}
+
+#endif  /* _SCI_OBJECT_H_ */
+
diff --git a/drivers/scsi/isci/core/scu_completion_codes.h b/drivers/scsi/isci/core/scu_completion_codes.h
new file mode 100644
index 0000000..c8b329c
--- /dev/null
+++ b/drivers/scsi/isci/core/scu_completion_codes.h
@@ -0,0 +1,283 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCU_COMPLETION_CODES_HEADER_
+#define _SCU_COMPLETION_CODES_HEADER_
+
+/**
+ * This file contains the constants and macros for the SCU hardware completion
+ *    codes.
+ *
+ *
+ */
+
+#define SCU_COMPLETION_TYPE_SHIFT      28
+#define SCU_COMPLETION_TYPE_MASK       0x70000000
+
+/**
+ * SCU_COMPLETION_TYPE() -
+ *
+ * This macro constructs an SCU completion type
+ */
+#define SCU_COMPLETION_TYPE(type) \
+	((u32)(type) << SCU_COMPLETION_TYPE_SHIFT)
+
+/**
+ * SCU_COMPLETION_TYPE() -
+ *
+ * These macros contain the SCU completion types SCU_COMPLETION_TYPE
+ */
+#define SCU_COMPLETION_TYPE_TASK       SCU_COMPLETION_TYPE(0)
+#define SCU_COMPLETION_TYPE_SDMA       SCU_COMPLETION_TYPE(1)
+#define SCU_COMPLETION_TYPE_UFI        SCU_COMPLETION_TYPE(2)
+#define SCU_COMPLETION_TYPE_EVENT      SCU_COMPLETION_TYPE(3)
+#define SCU_COMPLETION_TYPE_NOTIFY     SCU_COMPLETION_TYPE(4)
+
+/**
+ *
+ *
+ * These constants provide the shift and mask values for the various parts of
+ * an SCU completion code.
+ */
+#define SCU_COMPLETION_STATUS_MASK       0x0FFC0000
+#define SCU_COMPLETION_TL_STATUS_MASK    0x0FC00000
+#define SCU_COMPLETION_TL_STATUS_SHIFT   22
+#define SCU_COMPLETION_SDMA_STATUS_MASK  0x003C0000
+#define SCU_COMPLETION_PEG_MASK          0x00010000
+#define SCU_COMPLETION_PORT_MASK         0x00007000
+#define SCU_COMPLETION_PE_MASK           SCU_COMPLETION_PORT_MASK
+#define SCU_COMPLETION_PE_SHIFT          12
+#define SCU_COMPLETION_INDEX_MASK        0x00000FFF
+
+/**
+ * SCU_GET_COMPLETION_TYPE() -
+ *
+ * This macro returns the SCU completion type.
+ */
+#define SCU_GET_COMPLETION_TYPE(completion_code) \
+	((completion_code) & SCU_COMPLETION_TYPE_MASK)
+
+/**
+ * SCU_GET_COMPLETION_STATUS() -
+ *
+ * This macro returns the SCU completion status.
+ */
+#define SCU_GET_COMPLETION_STATUS(completion_code) \
+	((completion_code) & SCU_COMPLETION_STATUS_MASK)
+
+/**
+ * SCU_GET_COMPLETION_TL_STATUS() -
+ *
+ * This macro returns the transport layer completion status.
+ */
+#define SCU_GET_COMPLETION_TL_STATUS(completion_code) \
+	((completion_code) & SCU_COMPLETION_TL_STATUS_MASK)
+
+/**
+ * SCU_MAKE_COMPLETION_STATUS() -
+ *
+ * This macro takes a completion code and performs the shift and mask
+ * operations to turn it into a completion code that can be compared to a
+ * SCU_GET_COMPLETION_TL_STATUS.
+ */
+#define SCU_MAKE_COMPLETION_STATUS(completion_code) \
+	((u32)(completion_code) << SCU_COMPLETION_TL_STATUS_SHIFT)
+
+/**
+ * SCU_NORMALIZE_COMPLETION_STATUS() -
+ *
+ * This macro takes a SCU_GET_COMPLETION_TL_STATUS and normalizes it for a
+ * return code.
+ */
+#define SCU_NORMALIZE_COMPLETION_STATUS(completion_code) \
+	(\
+		((completion_code) & SCU_COMPLETION_TL_STATUS_MASK) \
+		>> SCU_COMPLETION_TL_STATUS_SHIFT \
+	)
+
+/**
+ * SCU_GET_COMPLETION_SDMA_STATUS() -
+ *
+ * This macro returns the SDMA completion status.
+ */
+#define SCU_GET_COMPLETION_SDMA_STATUS(completion_code)	\
+	((completion_code) & SCU_COMPLETION_SDMA_STATUS_MASK)
+
+/**
+ * SCU_GET_COMPLETION_PEG() -
+ *
+ * This macro returns the Protocol Engine Group from the completion code.
+ */
+#define SCU_GET_COMPLETION_PEG(completion_code)	\
+	((completion_code) & SCU_COMPLETION_PEG_MASK)
+
+/**
+ * SCU_GET_COMPLETION_PORT() -
+ *
+ * This macro reuturns the logical port index from the completion code.
+ */
+#define SCU_GET_COMPLETION_PORT(completion_code) \
+	((completion_code) & SCU_COMPLETION_PORT_MASK)
+
+/**
+ * SCU_GET_PROTOCOL_ENGINE_INDEX() -
+ *
+ * This macro returns the PE index from the completion code.
+ */
+#define SCU_GET_PROTOCOL_ENGINE_INDEX(completion_code) \
+	(((completion_code) & SCU_COMPLETION_PE_MASK) >> SCU_COMPLETION_PE_SHIFT)
+
+/**
+ * SCU_GET_COMPLETION_INDEX() -
+ *
+ * This macro returns the index of the completion which is either a TCi or an
+ * RNi depending on the completion type.
+ */
+#define SCU_GET_COMPLETION_INDEX(completion_code) \
+	((completion_code) & SCU_COMPLETION_INDEX_MASK)
+
+#define SCU_UNSOLICITED_FRAME_MASK     0x0FFF0000
+#define SCU_UNSOLICITED_FRAME_SHIFT    16
+
+/**
+ * SCU_GET_FRAME_INDEX() -
+ *
+ * This macro returns a normalized frame index from an unsolicited frame
+ * completion.
+ */
+#define SCU_GET_FRAME_INDEX(completion_code) \
+	(\
+		((completion_code) & SCU_UNSOLICITED_FRAME_MASK) \
+		>> SCU_UNSOLICITED_FRAME_SHIFT \
+	)
+
+#define SCU_UNSOLICITED_FRAME_ERROR_MASK  0x00008000
+
+/**
+ * SCU_GET_FRAME_ERROR() -
+ *
+ * This macro returns a zero (0) value if there is no frame error otherwise it
+ * returns non-zero (!0).
+ */
+#define SCU_GET_FRAME_ERROR(completion_code) \
+	((completion_code) & SCU_UNSOLICITED_FRAME_ERROR_MASK)
+
+/**
+ *
+ *
+ * These constants represent normalized completion codes which must be shifted
+ * 18 bits to match it with the hardware completion code. In a 16-bit compiler,
+ * immediate constants are 16-bit values (the size of an int). If we shift
+ * those by 18 bits, we completely lose the value. To ensure the value is a
+ * 32-bit value like we want, each immediate value must be cast to a u32.
+ */
+#define SCU_TASK_DONE_GOOD                                  ((u32)0x00)
+#define SCU_TASK_DONE_CRC_ERR                               ((u32)0x14)
+#define SCU_TASK_DONE_CHECK_RESPONSE                        ((u32)0x14)
+#define SCU_TASK_DONE_GEN_RESPONSE                          ((u32)0x15)
+#define SCU_TASK_DONE_NAK_CMD_ERR                           ((u32)0x16)
+#define SCU_TASK_DONE_CMD_LL_R_ERR                          ((u32)0x16)
+#define SCU_TASK_DONE_LL_R_ERR                              ((u32)0x17)
+#define SCU_TASK_DONE_ACK_NAK_TO                            ((u32)0x17)
+#define SCU_TASK_DONE_LL_PERR                               ((u32)0x18)
+#define SCU_TASK_DONE_LL_SY_TERM                            ((u32)0x19)
+#define SCU_TASK_DONE_NAK_ERR                               ((u32)0x19)
+#define SCU_TASK_DONE_LL_LF_TERM                            ((u32)0x1A)
+#define SCU_TASK_DONE_DATA_LEN_ERR                          ((u32)0x1A)
+#define SCU_TASK_DONE_LL_CL_TERM                            ((u32)0x1B)
+#define SCU_TASK_DONE_LL_ABORT_ERR                          ((u32)0x1B)
+#define SCU_TASK_DONE_SEQ_INV_TYPE                          ((u32)0x1C)
+#define SCU_TASK_DONE_UNEXP_XR                              ((u32)0x1C)
+#define SCU_TASK_DONE_INV_FIS_TYPE                          ((u32)0x1D)
+#define SCU_TASK_DONE_XR_IU_LEN_ERR                         ((u32)0x1D)
+#define SCU_TASK_DONE_INV_FIS_LEN                           ((u32)0x1E)
+#define SCU_TASK_DONE_XR_WD_LEN                             ((u32)0x1E)
+#define SCU_TASK_DONE_SDMA_ERR                              ((u32)0x1F)
+#define SCU_TASK_DONE_OFFSET_ERR                            ((u32)0x20)
+#define SCU_TASK_DONE_MAX_PLD_ERR                           ((u32)0x21)
+#define SCU_TASK_DONE_EXCESS_DATA                           ((u32)0x22)
+#define SCU_TASK_DONE_LF_ERR                                ((u32)0x23)
+#define SCU_TASK_DONE_UNEXP_FIS                             ((u32)0x24)
+#define SCU_TASK_DONE_UNEXP_RESP                            ((u32)0x24)
+#define SCU_TASK_DONE_EARLY_RESP                            ((u32)0x25)
+#define SCU_TASK_DONE_SMP_RESP_TO_ERR                       ((u32)0x26)
+#define SCU_TASK_DONE_DMASETUP_DIRERR                       ((u32)0x27)
+#define SCU_TASK_DONE_SMP_UFI_ERR                           ((u32)0x27)
+#define SCU_TASK_DONE_XFERCNT_ERR                           ((u32)0x28)
+#define SCU_TASK_DONE_SMP_FRM_TYPE_ERR                      ((u32)0x28)
+#define SCU_TASK_DONE_SMP_LL_RX_ERR                         ((u32)0x29)
+#define SCU_TASK_DONE_RESP_LEN_ERR                          ((u32)0x2A)
+#define SCU_TASK_DONE_UNEXP_DATA                            ((u32)0x2B)
+#define SCU_TASK_DONE_OPEN_FAIL                             ((u32)0x2C)
+#define SCU_TASK_DONE_UNEXP_SDBFIS                          ((u32)0x2D)
+#define SCU_TASK_DONE_REG_ERR                               ((u32)0x2E)
+#define SCU_TASK_DONE_SDB_ERR                               ((u32)0x2F)
+#define SCU_TASK_DONE_TASK_ABORT                            ((u32)0x30)
+#define SCU_TASK_DONE_CMD_SDMA_ERR                          ((U32)0x32)
+#define SCU_TASK_DONE_CMD_LL_ABORT_ERR                      ((U32)0x33)
+#define SCU_TASK_OPEN_REJECT_WRONG_DESTINATION              ((u32)0x34)
+#define SCU_TASK_OPEN_REJECT_RESERVED_ABANDON_1             ((u32)0x35)
+#define SCU_TASK_OPEN_REJECT_RESERVED_ABANDON_2             ((u32)0x36)
+#define SCU_TASK_OPEN_REJECT_RESERVED_ABANDON_3             ((u32)0x37)
+#define SCU_TASK_OPEN_REJECT_BAD_DESTINATION                ((u32)0x38)
+#define SCU_TASK_OPEN_REJECT_ZONE_VIOLATION                 ((u32)0x39)
+#define SCU_TASK_DONE_VIIT_ENTRY_NV                         ((u32)0x3A)
+#define SCU_TASK_DONE_IIT_ENTRY_NV                          ((u32)0x3B)
+#define SCU_TASK_DONE_RNCNV_OUTBOUND                        ((u32)0x3C)
+#define SCU_TASK_OPEN_REJECT_STP_RESOURCES_BUSY             ((u32)0x3D)
+#define SCU_TASK_OPEN_REJECT_PROTOCOL_NOT_SUPPORTED         ((u32)0x3E)
+#define SCU_TASK_OPEN_REJECT_CONNECTION_RATE_NOT_SUPPORTED  ((u32)0x3F)
+
+#endif /* _SCU_COMPLETION_CODES_HEADER_ */
diff --git a/drivers/scsi/isci/core/scu_constants.h b/drivers/scsi/isci/core/scu_constants.h
new file mode 100644
index 0000000..a99d110
--- /dev/null
+++ b/drivers/scsi/isci/core/scu_constants.h
@@ -0,0 +1,151 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCU_CONSTANTS_H_
+#define _SCU_CONSTANTS_H_
+
+/**
+ * This file contains the SCU hardware constants.
+ *
+ *
+ */
+
+#include "sci_controller_constants.h"
+
+/**
+ *
+ *
+ * 2 indicates the maximum number of UFs that can occur for a given IO request.
+ *  The hardware handles reception of additional unsolicited frames while all
+ * UFs are in use, by holding off the transmitting device.  This number could
+ * be theoretically reduced to 1, but 2 provides for more reliable operation.
+ * During SATA PIO operation, it is possible under some conditions for there to
+ * be 3 separate FISes received, back to back to back (PIO Setup, Data, D2H
+ * Register). It is unlikely to have all 3 pending all at once without some of
+ * them already being processed.
+ */
+#define SCU_MIN_UNSOLICITED_FRAMES        (1)
+#define SCU_MIN_CRITICAL_NOTIFICATIONS    (24)
+#define SCU_MIN_EVENTS                    (4)
+#define SCU_MIN_COMPLETION_QUEUE_SCRATCH  (2)
+#define SCU_MIN_COMPLETION_QUEUE_ENTRIES  (SCU_MIN_CRITICAL_NOTIFICATIONS \
+					   + SCU_MIN_EVENTS \
+					   + SCU_MIN_UNSOLICITED_FRAMES	\
+					   + SCI_MIN_IO_REQUESTS \
+					   + SCU_MIN_COMPLETION_QUEUE_SCRATCH)
+
+#define SCU_MAX_CRITICAL_NOTIFICATIONS    (384)
+#define SCU_MAX_EVENTS                    (128)
+#define SCU_MAX_UNSOLICITED_FRAMES        (128)
+#define SCU_MAX_COMPLETION_QUEUE_SCRATCH  (128)
+#define SCU_MAX_COMPLETION_QUEUE_ENTRIES  (SCU_MAX_CRITICAL_NOTIFICATIONS \
+					   + SCU_MAX_EVENTS \
+					   + SCU_MAX_UNSOLICITED_FRAMES	\
+					   + SCI_MAX_IO_REQUESTS \
+					   + SCU_MAX_COMPLETION_QUEUE_SCRATCH)
+
+#if !defined(ENABLE_MINIMUM_MEMORY_MODE)
+#define SCU_UNSOLICITED_FRAME_COUNT      SCU_MAX_UNSOLICITED_FRAMES
+#define SCU_CRITICAL_NOTIFICATION_COUNT  SCU_MAX_CRITICAL_NOTIFICATIONS
+#define SCU_EVENT_COUNT                  SCU_MAX_EVENTS
+#define SCU_COMPLETION_QUEUE_SCRATCH     SCU_MAX_COMPLETION_QUEUE_SCRATCH
+#define SCU_IO_REQUEST_COUNT             SCI_MAX_IO_REQUESTS
+#define SCU_IO_REQUEST_SGE_COUNT         SCI_MAX_SCATTER_GATHER_ELEMENTS
+#define SCU_COMPLETION_QUEUE_COUNT       SCU_MAX_COMPLETION_QUEUE_ENTRIES
+#else
+#define SCU_UNSOLICITED_FRAME_COUNT      SCU_MIN_UNSOLICITED_FRAMES
+#define SCU_CRITICAL_NOTIFICATION_COUNT  SCU_MIN_CRITICAL_NOTIFICATIONS
+#define SCU_EVENT_COUNT                  SCU_MIN_EVENTS
+#define SCU_COMPLETION_QUEUE_SCRATCH     SCU_MIN_COMPLETION_QUEUE_SCRATCH
+#define SCU_IO_REQUEST_COUNT             SCI_MIN_IO_REQUESTS
+#define SCU_IO_REQUEST_SGE_COUNT         SCI_MIN_SCATTER_GATHER_ELEMENTS
+#define SCU_COMPLETION_QUEUE_COUNT       SCU_MIN_COMPLETION_QUEUE_ENTRIES
+#endif /* !defined(ENABLE_MINIMUM_MEMORY_OPERATION) */
+
+/**
+ *
+ *
+ * The SCU_COMPLETION_QUEUE_COUNT constant indicates the size of the completion
+ * queue into which the hardware DMAs 32-bit quantas (completion entries).
+ */
+
+/**
+ *
+ *
+ * This queue must be programmed to a power of 2 size (e.g. 32, 64, 1024, etc.).
+ */
+#if (SCU_COMPLETION_QUEUE_COUNT != 16)  && \
+	(SCU_COMPLETION_QUEUE_COUNT != 32)  && \
+	(SCU_COMPLETION_QUEUE_COUNT != 64)  && \
+	(SCU_COMPLETION_QUEUE_COUNT != 128) && \
+	(SCU_COMPLETION_QUEUE_COUNT != 256) && \
+	(SCU_COMPLETION_QUEUE_COUNT != 512) && \
+	(SCU_COMPLETION_QUEUE_COUNT != 1024)
+#error "SCU_COMPLETION_QUEUE_COUNT must be set to a power of 2."
+#endif
+
+#if SCU_MIN_UNSOLICITED_FRAMES > SCU_MAX_UNSOLICITED_FRAMES
+#error "Invalid configuration of unsolicited frame constants"
+#endif /* SCU_MIN_UNSOLICITED_FRAMES > SCU_MAX_UNSOLICITED_FRAMES */
+
+#define SCU_MIN_UF_TABLE_ENTRIES            (8)
+#define SCU_ABSOLUTE_MAX_UNSOLICITED_FRAMES (4096)
+#define SCU_UNSOLICITED_FRAME_BUFFER_SIZE   (1024)
+#define SCU_INVALID_FRAME_INDEX             (0xFFFF)
+
+#define SCU_IO_REQUEST_MAX_SGE_SIZE         (0x00FFFFFF)
+#define SCU_IO_REQUEST_MAX_TRANSFER_LENGTH  (0x00FFFFFF)
+
+#endif /* _SCU_CONSTANTS_H_ */
diff --git a/drivers/scsi/isci/core/scu_event_codes.h b/drivers/scsi/isci/core/scu_event_codes.h
new file mode 100644
index 0000000..36a945a
--- /dev/null
+++ b/drivers/scsi/isci/core/scu_event_codes.h
@@ -0,0 +1,336 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __SCU_EVENT_CODES_HEADER__
+#define __SCU_EVENT_CODES_HEADER__
+
+/**
+ * This file contains the constants and macros for the SCU event codes.
+ *
+ *
+ */
+
+#define SCU_EVENT_TYPE_CODE_SHIFT      24
+#define SCU_EVENT_TYPE_CODE_MASK       0x0F000000
+
+#define SCU_EVENT_SPECIFIC_CODE_SHIFT  18
+#define SCU_EVENT_SPECIFIC_CODE_MASK   0x00FC0000
+
+#define SCU_EVENT_CODE_MASK \
+	(SCU_EVENT_TYPE_CODE_MASK | SCU_EVENT_SPECIFIC_CODE_MASK)
+
+/**
+ * SCU_EVENT_TYPE() -
+ *
+ * This macro constructs an SCU event type from the type value.
+ */
+#define SCU_EVENT_TYPE(type) \
+	((u32)(type) << SCU_EVENT_TYPE_CODE_SHIFT)
+
+/**
+ * SCU_EVENT_SPECIFIC() -
+ *
+ * This macro constructs an SCU event specifier from the code value.
+ */
+#define SCU_EVENT_SPECIFIC(code) \
+	((u32)(code) << SCU_EVENT_SPECIFIC_CODE_SHIFT)
+
+/**
+ * SCU_EVENT_MESSAGE() -
+ *
+ * This macro constructs a combines an SCU event type and SCU event specifier
+ * from the type and code values.
+ */
+#define SCU_EVENT_MESSAGE(type, code) \
+	((type) | SCU_EVENT_SPECIFIC(code))
+
+/**
+ * SCU_EVENT_TYPE() -
+ *
+ * SCU_EVENT_TYPES
+ */
+#define SCU_EVENT_TYPE_SMU_COMMAND_ERROR  SCU_EVENT_TYPE(0x08)
+#define SCU_EVENT_TYPE_SMU_PCQ_ERROR      SCU_EVENT_TYPE(0x09)
+#define SCU_EVENT_TYPE_SMU_ERROR          SCU_EVENT_TYPE(0x00)
+#define SCU_EVENT_TYPE_TRANSPORT_ERROR    SCU_EVENT_TYPE(0x01)
+#define SCU_EVENT_TYPE_BROADCAST_CHANGE   SCU_EVENT_TYPE(0x02)
+#define SCU_EVENT_TYPE_OSSP_EVENT         SCU_EVENT_TYPE(0x03)
+#define SCU_EVENT_TYPE_FATAL_MEMORY_ERROR SCU_EVENT_TYPE(0x0F)
+#define SCU_EVENT_TYPE_RNC_SUSPEND_TX     SCU_EVENT_TYPE(0x04)
+#define SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX  SCU_EVENT_TYPE(0x05)
+#define SCU_EVENT_TYPE_RNC_OPS_MISC       SCU_EVENT_TYPE(0x06)
+#define SCU_EVENT_TYPE_PTX_SCHEDULE_EVENT SCU_EVENT_TYPE(0x07)
+#define SCU_EVENT_TYPE_ERR_CNT_EVENT      SCU_EVENT_TYPE(0x0A)
+
+/**
+ *
+ *
+ * SCU_EVENT_SPECIFIERS
+ */
+#define SCU_EVENT_SPECIFIER_DRIVER_SUSPEND 0x20
+#define SCU_EVENT_SPECIFIER_RNC_RELEASE    0x00
+
+/**
+ *
+ *
+ * SMU_COMMAND_EVENTS
+ */
+#define SCU_EVENT_INVALID_CONTEXT_COMMAND \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_SMU_COMMAND_ERROR, 0x00)
+
+/**
+ *
+ *
+ * SMU_PCQ_EVENTS
+ */
+#define SCU_EVENT_UNCORRECTABLE_PCQ_ERROR \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_SMU_PCQ_ERROR, 0x00)
+
+/**
+ *
+ *
+ * SMU_EVENTS
+ */
+#define SCU_EVENT_UNCORRECTABLE_REGISTER_WRITE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_SMU_ERROR, 0x02)
+#define SCU_EVENT_UNCORRECTABLE_REGISTER_READ \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_SMU_ERROR, 0x03)
+#define SCU_EVENT_PCIE_INTERFACE_ERROR \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_SMU_ERROR, 0x04)
+#define SCU_EVENT_FUNCTION_LEVEL_RESET \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_SMU_ERROR, 0x05)
+
+/**
+ *
+ *
+ * TRANSPORT_LEVEL_ERRORS
+ */
+#define SCU_EVENT_ACK_NAK_TIMEOUT_ERROR	\
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_TRANSPORT_ERROR, 0x00)
+
+/**
+ *
+ *
+ * BROADCAST_CHANGE_EVENTS
+ */
+#define SCU_EVENT_BROADCAST_CHANGE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x01)
+#define SCU_EVENT_BROADCAST_RESERVED0 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x02)
+#define SCU_EVENT_BROADCAST_RESERVED1 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x03)
+#define SCU_EVENT_BROADCAST_SES	\
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x04)
+#define SCU_EVENT_BROADCAST_EXPANDER \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x05)
+#define SCU_EVENT_BROADCAST_AEN	\
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x06)
+#define SCU_EVENT_BROADCAST_RESERVED3 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x07)
+#define SCU_EVENT_BROADCAST_RESERVED4 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x08)
+#define SCU_EVENT_PE_SUSPENDED \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_BROADCAST_CHANGE, 0x09)
+
+/**
+ *
+ *
+ * OSSP_EVENTS
+ */
+#define SCU_EVENT_PORT_SELECTOR_DETECTED \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x10)
+#define SCU_EVENT_SENT_PORT_SELECTION \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x11)
+#define SCU_EVENT_HARD_RESET_TRANSMITTED \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x12)
+#define SCU_EVENT_HARD_RESET_RECEIVED \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x13)
+#define SCU_EVENT_RECEIVED_IDENTIFY_TIMEOUT \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x15)
+#define SCU_EVENT_LINK_FAILURE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x16)
+#define SCU_EVENT_SATA_SPINUP_HOLD \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x17)
+#define SCU_EVENT_SAS_15_SSC \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x18)
+#define SCU_EVENT_SAS_15 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x19)
+#define SCU_EVENT_SAS_30_SSC \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x1A)
+#define SCU_EVENT_SAS_30 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x1B)
+#define SCU_EVENT_SAS_60_SSC \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x1C)
+#define SCU_EVENT_SAS_60 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x1D)
+#define SCU_EVENT_SATA_15_SSC \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x1E)
+#define SCU_EVENT_SATA_15 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x1F)
+#define SCU_EVENT_SATA_30_SSC \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x20)
+#define SCU_EVENT_SATA_30 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x21)
+#define SCU_EVENT_SATA_60_SSC \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x22)
+#define SCU_EVENT_SATA_60 \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x23)
+#define SCU_EVENT_SAS_PHY_DETECTED \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x24)
+#define SCU_EVENT_SATA_PHY_DETECTED \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_OSSP_EVENT, 0x25)
+
+/**
+ *
+ *
+ * FATAL_INTERNAL_MEMORY_ERROR_EVENTS
+ */
+#define SCU_EVENT_TSC_RNSC_UNCORRECTABLE_ERROR \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_FATAL_MEMORY_ERROR,  0x00)
+#define SCU_EVENT_TC_RNC_UNCORRECTABLE_ERROR \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_FATAL_MEMORY_ERROR,  0x01)
+#define SCU_EVENT_ZPT_UNCORRECTABLE_ERROR \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_FATAL_MEMORY_ERROR,  0x02)
+
+/**
+ *
+ *
+ * REMOTE_NODE_SUSPEND_EVENTS
+ */
+#define SCU_EVENT_TL_RNC_SUSPEND_TX \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_SUSPEND_TX, 0x00)
+#define SCU_EVENT_TL_RNC_SUSPEND_TX_RX \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX, 0x00)
+#define SCU_EVENT_DRIVER_POST_RNC_SUSPEND_TX \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_SUSPEND_TX, 0x20)
+#define SCU_EVENT_DRIVER_POST_RNC_SUSPEND_TX_RX	\
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX, 0x20)
+
+/**
+ *
+ *
+ * REMOTE_NODE_MISC_EVENTS
+ */
+#define SCU_EVENT_POST_RCN_RELEASE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_OPS_MISC, SCU_EVENT_SPECIFIER_RNC_RELEASE)
+#define SCU_EVENT_POST_IT_NEXUS_LOSS_TIMER_ENABLE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_OPS_MISC, 0x01)
+#define SCU_EVENT_POST_IT_NEXUS_LOSS_TIMER_DISABLE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_OPS_MISC, 0x02)
+#define SCU_EVENT_POST_RNC_COMPLETE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_OPS_MISC, 0x03)
+#define SCU_EVENT_POST_RNC_INVALIDATE_COMPLETE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_RNC_OPS_MISC, 0x04)
+
+/**
+ *
+ *
+ * ERROR_COUNT_EVENT
+ */
+#define SCU_EVENT_RX_CREDIT_BLOCKED_RECEIVED \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_ERR_CNT_EVENT, 0x00)
+#define SCU_EVENT_TX_DONE_CREDIT_TIMEOUT \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_ERR_CNT_EVENT, 0x01)
+#define SCU_EVENT_RX_DONE_CREDIT_TIMEOUT \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_ERR_CNT_EVENT, 0x02)
+
+/**
+ * scu_get_event_type() -
+ *
+ * This macro returns the SCU event type from the event code.
+ */
+#define scu_get_event_type(event_code) \
+	((event_code) & SCU_EVENT_TYPE_CODE_MASK)
+
+/**
+ * scu_get_event_specifier() -
+ *
+ * This macro returns the SCU event specifier from the event code.
+ */
+#define scu_get_event_specifier(event_code) \
+	((event_code) & SCU_EVENT_SPECIFIC_CODE_MASK)
+
+/**
+ * scu_get_event_code() -
+ *
+ * This macro returns the combined SCU event type and SCU event specifier from
+ * the event code.
+ */
+#define scu_get_event_code(event_code) \
+	((event_code) & SCU_EVENT_CODE_MASK)
+
+
+/**
+ *
+ *
+ * PTS_SCHEDULE_EVENT
+ */
+#define SCU_EVENT_SMP_RESPONSE_NO_PE \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_PTX_SCHEDULE_EVENT, 0x00)
+#define SCU_EVENT_SPECIFIC_SMP_RESPONSE_NO_PE \
+	scu_get_event_specifier(SCU_EVENT_SMP_RESPONSE_NO_PE)
+
+#define SCU_EVENT_TASK_TIMEOUT \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_PTX_SCHEDULE_EVENT, 0x01)
+#define SCU_EVENT_SPECIFIC_TASK_TIMEOUT	\
+	scu_get_event_specifier(SCU_EVENT_TASK_TIMEOUT)
+
+#define SCU_EVENT_IT_NEXUS_TIMEOUT \
+	SCU_EVENT_MESSAGE(SCU_EVENT_TYPE_PTX_SCHEDULE_EVENT, 0x02)
+#define SCU_EVENT_SPECIFIC_IT_NEXUS_TIMEOUT \
+	scu_get_event_specifier(SCU_EVENT_IT_NEXUS_TIMEOUT)
+
+
+#endif /* __SCU_EVENT_CODES_HEADER__ */
diff --git a/drivers/scsi/isci/core/scu_task_context.h b/drivers/scsi/isci/core/scu_task_context.h
new file mode 100644
index 0000000..818a575
--- /dev/null
+++ b/drivers/scsi/isci/core/scu_task_context.h
@@ -0,0 +1,942 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCU_TASK_CONTEXT_H_
+#define _SCU_TASK_CONTEXT_H_
+
+/**
+ * This file contains the structures and constants for the SCU hardware task
+ *    context.
+ *
+ *
+ */
+
+
+/**
+ * enum SCU_SSP_TASK_TYPE - This enumberation defines the various SSP task
+ *    types the SCU hardware will accept. The definition for the various task
+ *    types the SCU hardware will accept can be found in the DS specification.
+ *
+ *
+ */
+typedef enum {
+	SCU_TASK_TYPE_IOREAD,           /* /< IO READ direction or no direction */
+	SCU_TASK_TYPE_IOWRITE,          /* /< IO Write direction */
+	SCU_TASK_TYPE_SMP_REQUEST,      /* /< SMP Request type */
+	SCU_TASK_TYPE_RESPONSE,         /* /< Driver generated response frame (targt mode) */
+	SCU_TASK_TYPE_RAW_FRAME,        /* /< Raw frame request type */
+	SCU_TASK_TYPE_PRIMITIVE         /* /< Request for a primitive to be transmitted */
+} SCU_SSP_TASK_TYPE;
+
+/**
+ * enum SCU_SATA_TASK_TYPE - This enumeration defines the various SATA task
+ *    types the SCU hardware will accept. The definition for the various task
+ *    types the SCU hardware will accept can be found in the DS specification.
+ *
+ *
+ */
+typedef enum {
+	SCU_TASK_TYPE_DMA_IN,           /* /< Read request */
+	SCU_TASK_TYPE_FPDMAQ_READ,      /* /< NCQ read request */
+	SCU_TASK_TYPE_PACKET_DMA_IN,    /* /< Packet read request */
+	SCU_TASK_TYPE_SATA_RAW_FRAME,   /* /< Raw frame request */
+	RESERVED_4,
+	RESERVED_5,
+	RESERVED_6,
+	RESERVED_7,
+	SCU_TASK_TYPE_DMA_OUT,          /* /< Write request */
+	SCU_TASK_TYPE_FPDMAQ_WRITE,     /* /< NCQ write Request */
+	SCU_TASK_TYPE_PACKET_DMA_OUT    /* /< Packet write request */
+} SCU_SATA_TASK_TYPE;
+
+
+/**
+ *
+ *
+ * SCU_CONTEXT_TYPE
+ */
+#define SCU_TASK_CONTEXT_TYPE  0
+#define SCU_RNC_CONTEXT_TYPE   1
+
+/**
+ *
+ *
+ * SCU_TASK_CONTEXT_VALIDITY
+ */
+#define SCU_TASK_CONTEXT_INVALID          0
+#define SCU_TASK_CONTEXT_VALID            1
+
+/**
+ *
+ *
+ * SCU_COMMAND_CODE
+ */
+#define SCU_COMMAND_CODE_INITIATOR_NEW_TASK   0
+#define SCU_COMMAND_CODE_ACTIVE_TASK          1
+#define SCU_COMMAND_CODE_PRIMITIVE_SEQ_TASK   2
+#define SCU_COMMAND_CODE_TARGET_RAW_FRAMES    3
+
+/**
+ *
+ *
+ * SCU_TASK_PRIORITY
+ */
+/**
+ *
+ *
+ * This priority is used when there is no priority request for this request.
+ */
+#define SCU_TASK_PRIORITY_NORMAL          0
+
+/**
+ *
+ *
+ * This priority indicates that the task should be scheduled to the head of the
+ * queue.  The task will NOT be executed if the TX is suspended for the remote
+ * node.
+ */
+#define SCU_TASK_PRIORITY_HEAD_OF_Q       1
+
+/**
+ *
+ *
+ * This priority indicates that the task will be executed before all
+ * SCU_TASK_PRIORITY_NORMAL and SCU_TASK_PRIORITY_HEAD_OF_Q tasks. The task
+ * WILL be executed if the TX is suspended for the remote node.
+ */
+#define SCU_TASK_PRIORITY_HIGH            2
+
+/**
+ *
+ *
+ * This task priority is reserved and should not be used.
+ */
+#define SCU_TASK_PRIORITY_RESERVED        3
+
+#define SCU_TASK_INITIATOR_MODE           1
+#define SCU_TASK_TARGET_MODE              0
+
+#define SCU_TASK_REGULAR                  0
+#define SCU_TASK_ABORTED                  1
+
+/* direction bit defintion */
+/**
+ *
+ *
+ * SATA_DIRECTION
+ */
+#define SCU_SATA_WRITE_DATA_DIRECTION     0
+#define SCU_SATA_READ_DATA_DIRECTION      1
+
+/**
+ *
+ *
+ * SCU_COMMAND_CONTEXT_MACROS These macros provide the mask and shift
+ * operations to construct the various SCU commands
+ */
+#define SCU_CONTEXT_COMMAND_REQUEST_TYPE_SHIFT           21
+#define SCU_CONTEXT_COMMAND_REQUEST_TYPE_MASK            0x00E00000
+#define scu_get_command_request_type(x)	\
+	((x) & SCU_CONTEXT_COMMAND_REQUEST_TYPE_MASK)
+
+#define SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_SHIFT        18
+#define SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_MASK         0x001C0000
+#define scu_get_command_request_subtype(x) \
+	((x) & SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_MASK)
+
+#define SCU_CONTEXT_COMMAND_REQUEST_FULLTYPE_MASK	 \
+	(\
+		SCU_CONTEXT_COMMAND_REQUEST_TYPE_MASK		  \
+		| SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_MASK	    \
+	)
+#define scu_get_command_request_full_type(x) \
+	((x) & SCU_CONTEXT_COMMAND_REQUEST_FULLTYPE_MASK)
+
+#define SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_SHIFT  16
+#define SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_MASK   0x00010000
+#define scu_get_command_protocl_engine_group(x)	\
+	((x) & SCU_CONTEXT_COMMAND_PROTOCOL_ENGINE_GROUP_MASK)
+
+#define SCU_CONTEXT_COMMAND_LOGICAL_PORT_SHIFT           12
+#define SCU_CONTEXT_COMMAND_LOGICAL_PORT_MASK            0x00007000
+#define scu_get_command_reqeust_logical_port(x)	\
+	((x) & SCU_CONTEXT_COMMAND_LOGICAL_PORT_MASK)
+
+
+#define MAKE_SCU_CONTEXT_COMMAND_TYPE(type) \
+	((u32)(type) << SCU_CONTEXT_COMMAND_REQUEST_TYPE_SHIFT)
+
+/**
+ * MAKE_SCU_CONTEXT_COMMAND_TYPE() -
+ *
+ * SCU_COMMAND_TYPES These constants provide the grouping of the different SCU
+ * command types.
+ */
+#define SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_TC    MAKE_SCU_CONTEXT_COMMAND_TYPE(0)
+#define SCU_CONTEXT_COMMAND_REQUEST_TYPE_DUMP_TC    MAKE_SCU_CONTEXT_COMMAND_TYPE(1)
+#define SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_RNC   MAKE_SCU_CONTEXT_COMMAND_TYPE(2)
+#define SCU_CONTEXT_COMMAND_REQUEST_TYPE_DUMP_RNC   MAKE_SCU_CONTEXT_COMMAND_TYPE(3)
+#define SCU_CONTEXT_COMMAND_REQUEST_TYPE_OTHER_RNC  MAKE_SCU_CONTEXT_COMMAND_TYPE(6)
+
+#define MAKE_SCU_CONTEXT_COMMAND_REQUEST(type, command)	\
+	((type) | ((command) << SCU_CONTEXT_COMMAND_REQUEST_SUBTYPE_SHIFT))
+
+/**
+ *
+ *
+ * SCU_REQUEST_TYPES These constants are the various request types that can be
+ * posted to the SCU hardware.
+ */
+#define SCU_CONTEXT_COMMAND_REQUST_POST_TC \
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_TC, 0))
+
+#define SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT \
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_TC, 1))
+
+#define SCU_CONTEXT_COMMAND_REQUST_DUMP_TC \
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_DUMP_TC, 0))
+
+#define SCU_CONTEXT_COMMAND_POST_RNC_32	\
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_RNC, 0))
+
+#define SCU_CONTEXT_COMMAND_POST_RNC_96	\
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_RNC, 1))
+
+#define SCU_CONTEXT_COMMAND_POST_RNC_INVALIDATE	\
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_POST_RNC, 2))
+
+#define SCU_CONTEXT_COMMAND_DUMP_RNC_32	\
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_DUMP_RNC, 0))
+
+#define SCU_CONTEXT_COMMAND_DUMP_RNC_96	\
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_DUMP_RNC, 1))
+
+#define SCU_CONTEXT_COMMAND_POST_RNC_SUSPEND_TX	\
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_OTHER_RNC, 0))
+
+#define SCU_CONTEXT_COMMAND_POST_RNC_SUSPEND_TX_RX \
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_OTHER_RNC, 1))
+
+#define SCU_CONTEXT_COMMAND_POST_RNC_RESUME \
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_OTHER_RNC, 2))
+
+#define SCU_CONTEXT_IT_NEXUS_LOSS_TIMER_ENABLE \
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_OTHER_RNC, 3))
+
+#define SCU_CONTEXT_IT_NEXUS_LOSS_TIMER_DISABLE	\
+	(MAKE_SCU_CONTEXT_COMMAND_REQUEST(SCU_CONTEXT_COMMAND_REQUEST_TYPE_OTHER_RNC, 4))
+
+/**
+ *
+ *
+ * SCU_TASK_CONTEXT_PROTOCOL SCU Task context protocol types this is uesd to
+ * program the SCU Task context protocol field in word 0x00.
+ */
+#define SCU_TASK_CONTEXT_PROTOCOL_SMP    0x00
+#define SCU_TASK_CONTEXT_PROTOCOL_SSP    0x01
+#define SCU_TASK_CONTEXT_PROTOCOL_STP    0x02
+#define SCU_TASK_CONTEXT_PROTOCOL_NONE   0x07
+
+/**
+ * struct SSP_TASK_CONTEXT - This is the SCU hardware definition for an SSP
+ *    request.
+ *
+ *
+ */
+struct SSP_TASK_CONTEXT {
+	/* OFFSET 0x18 */
+	u32 reserved00:24;
+	u32 frame_type:8;
+
+	/* OFFSET 0x1C */
+	u32 reserved01;
+
+	/* OFFSET 0x20 */
+	u32 fill_bytes:2;
+	u32 reserved02:6;
+	u32 changing_data_pointer:1;
+	u32 retransmit:1;
+	u32 retry_data_frame:1;
+	u32 tlr_control:2;
+	u32 reserved03:19;
+
+	/* OFFSET 0x24 */
+	u32 uiRsvd4;
+
+	/* OFFSET 0x28 */
+	u32 target_port_transfer_tag:16;
+	u32 tag:16;
+
+	/* OFFSET 0x2C */
+	u32 data_offset;
+};
+
+/**
+ * struct STP_TASK_CONTEXT - This is the SCU hardware definition for an STP
+ *    request.
+ *
+ *
+ */
+struct STP_TASK_CONTEXT {
+	/* OFFSET 0x18 */
+	u32 fis_type:8;
+	u32 pm_port:4;
+	u32 reserved0:3;
+	u32 control:1;
+	u32 command:8;
+	u32 features:8;
+
+	/* OFFSET 0x1C */
+	u32 reserved1;
+
+	/* OFFSET 0x20 */
+	u32 reserved2;
+
+	/* OFFSET 0x24 */
+	u32 reserved3;
+
+	/* OFFSET 0x28 */
+	u32 ncq_tag:5;
+	u32 reserved4:27;
+
+	/* OFFSET 0x2C */
+	u32 data_offset; /* TODO: What is this used for? */
+};
+
+/**
+ * struct SMP_TASK_CONTEXT - This is the SCU hardware definition for an SMP
+ *    request.
+ *
+ *
+ */
+struct SMP_TASK_CONTEXT {
+	/* OFFSET 0x18 */
+	u32 response_length:8;
+	u32 function_result:8;
+	u32 function:8;
+	u32 frame_type:8;
+
+	/* OFFSET 0x1C */
+	u32 smp_response_ufi:12;
+	u32 reserved1:20;
+
+	/* OFFSET 0x20 */
+	u32 reserved2;
+
+	/* OFFSET 0x24 */
+	u32 reserved3;
+
+	/* OFFSET 0x28 */
+	u32 reserved4;
+
+	/* OFFSET 0x2C */
+	u32 reserved5;
+};
+
+/**
+ * struct PRIMITIVE_TASK_CONTEXT - This is the SCU hardware definition used
+ *    when the driver wants to send a primitive on the link.
+ *
+ *
+ */
+struct PRIMITIVE_TASK_CONTEXT {
+	/* OFFSET 0x18 */
+	/**
+	 * This field is the control word and it must be 0.
+	 */
+	u32 control; /* /< must be set to 0 */
+
+	/* OFFSET 0x1C */
+	/**
+	 * This field specifies the primitive that is to be transmitted.
+	 */
+	u32 sequence;
+
+	/* OFFSET 0x20 */
+	u32 reserved0;
+
+	/* OFFSET 0x24 */
+	u32 reserved1;
+
+	/* OFFSET 0x28 */
+	u32 reserved2;
+
+	/* OFFSET 0x2C */
+	u32 reserved3;
+};
+
+/**
+ * The union of the protocols that can be selected in the SCU task context
+ *    field.
+ *
+ * PROTOCOL_CONTEXT
+ */
+union PROTOCOL_CONTEXT {
+	struct SSP_TASK_CONTEXT ssp;
+	struct STP_TASK_CONTEXT stp;
+	struct SMP_TASK_CONTEXT smp;
+	struct PRIMITIVE_TASK_CONTEXT primitive;
+	u32 words[6];
+};
+
+/**
+ * struct scu_sgl_element - This structure represents a single SCU defined SGL
+ *    element. SCU SGLs contain a 64 bit address with the maximum data transfer
+ *    being 24 bits in size.  The SGL can not cross a 4GB boundary.
+ *
+ * struct scu_sgl_element
+ */
+struct scu_sgl_element {
+	/**
+	 * This field is the upper 32 bits of the 64 bit physical address.
+	 */
+	u32 address_upper;
+
+	/**
+	 * This field is the lower 32 bits of the 64 bit physical address.
+	 */
+	u32 address_lower;
+
+	/**
+	 * This field is the number of bytes to transfer.
+	 */
+	u32 length:24;
+
+	/**
+	 * This field is the address modifier to be used when a virtual function is
+	 * requesting a data transfer.
+	 */
+	u32 address_modifier:8;
+
+};
+
+#define SCU_SGL_ELEMENT_PAIR_A   0
+#define SCU_SGL_ELEMENT_PAIR_B   1
+
+/**
+ * struct scu_sgl_element_pair - This structure is the SCU hardware definition
+ *    of a pair of SGL elements. The SCU hardware always works on SGL pairs.
+ *    They are refered to in the DS specification as SGL A and SGL B.  Each SGL
+ *    pair is followed by the address of the next pair.
+ *
+ *
+ */
+struct scu_sgl_element_pair {
+	/* OFFSET 0x60-0x68 */
+	/**
+	 * This field is the SGL element A of the SGL pair.
+	 */
+	struct scu_sgl_element A;
+
+	/* OFFSET 0x6C-0x74 */
+	/**
+	 * This field is the SGL element B of the SGL pair.
+	 */
+	struct scu_sgl_element B;
+
+	/* OFFSET 0x78-0x7C */
+	/**
+	 * This field is the upper 32 bits of the 64 bit address to the next SGL
+	 * element pair.
+	 */
+	u32 next_pair_upper;
+
+	/**
+	 * This field is the lower 32 bits of the 64 bit address to the next SGL
+	 * element pair.
+	 */
+	u32 next_pair_lower;
+
+};
+
+/**
+ * struct TRANSPORT_SNAPSHOT - This structure is the SCU hardware scratch area
+ *    for the task context. This is set to 0 by the driver but can be read by
+ *    issuing a dump TC request to the SCU.
+ *
+ *
+ */
+struct TRANSPORT_SNAPSHOT {
+	/* OFFSET 0x48 */
+	u32 xfer_rdy_write_data_length;
+
+	/* OFFSET 0x4C */
+	u32 data_offset;
+
+	/* OFFSET 0x50 */
+	u32 data_transfer_size:24;
+	u32 reserved_50_0:8;
+
+	/* OFFSET 0x54 */
+	u32 next_initiator_write_data_offset;
+
+	/* OFFSET 0x58 */
+	u32 next_initiator_write_data_xfer_size:24;
+	u32 reserved_58_0:8;
+};
+
+/**
+ * struct scu_task_context - This structure defines the contents of the SCU
+ *    silicon task context. It lays out all of the fields according to the
+ *    expected order and location for the Storage Controller unit.
+ *
+ *
+ */
+struct scu_task_context {
+	/* OFFSET 0x00 ------ */
+	/**
+	 * This field must be encoded to one of the valid SCU task priority values
+	 *    - SCU_TASK_PRIORITY_NORMAL
+	 *    - SCU_TASK_PRIORITY_HEAD_OF_Q
+	 *    - SCU_TASK_PRIORITY_HIGH
+	 */
+	u32 priority:2;
+
+	/**
+	 * This field must be set to true if this is an initiator generated request.
+	 * Until target mode is supported all task requests are initiator requests.
+	 */
+	u32 initiator_request:1;
+
+	/**
+	 * This field must be set to one of the valid connection rates valid values
+	 * are 0x8, 0x9, and 0xA.
+	 */
+	u32 connection_rate:4;
+
+	/**
+	 * This field muse be programed when generating an SMP response since the SMP
+	 * connection remains open until the SMP response is generated.
+	 */
+	u32 protocol_engine_index:3;
+
+	/**
+	 * This field must contain the logical port for the task request.
+	 */
+	u32 logical_port_index:3;
+
+	/**
+	 * This field must be set to one of the SCU_TASK_CONTEXT_PROTOCOL values
+	 *    - SCU_TASK_CONTEXT_PROTOCOL_SMP
+	 *    - SCU_TASK_CONTEXT_PROTOCOL_SSP
+	 *    - SCU_TASK_CONTEXT_PROTOCOL_STP
+	 *    - SCU_TASK_CONTEXT_PROTOCOL_NONE
+	 */
+	u32 protocol_type:3;
+
+	/**
+	 * This filed must be set to the TCi allocated for this task
+	 */
+	u32 task_index:12;
+
+	/**
+	 * This field is reserved and must be set to 0x00
+	 */
+	u32 reserved_00_0:1;
+
+	/**
+	 * For a normal task request this must be set to 0.  If this is an abort of
+	 * this task request it must be set to 1.
+	 */
+	u32 abort:1;
+
+	/**
+	 * This field must be set to true for the SCU hardware to process the task.
+	 */
+	u32 valid:1;
+
+	/**
+	 * This field must be set to SCU_TASK_CONTEXT_TYPE
+	 */
+	u32 context_type:1;
+
+	/* OFFSET 0x04 */
+	/**
+	 * This field contains the RNi that is the target of this request.
+	 */
+	u32 remote_node_index:12;
+
+	/**
+	 * This field is programmed if this is a mirrored request, which we are not
+	 * using, in which case it is the RNi for the mirrored target.
+	 */
+	u32 mirrored_node_index:12;
+
+	/**
+	 * This field is programmed with the direction of the SATA reqeust
+	 *    - SCU_SATA_WRITE_DATA_DIRECTION
+	 *    - SCU_SATA_READ_DATA_DIRECTION
+	 */
+	u32 sata_direction:1;
+
+	/**
+	 * This field is programmsed with one of the following SCU_COMMAND_CODE
+	 *    - SCU_COMMAND_CODE_INITIATOR_NEW_TASK
+	 *    - SCU_COMMAND_CODE_ACTIVE_TASK
+	 *    - SCU_COMMAND_CODE_PRIMITIVE_SEQ_TASK
+	 *    - SCU_COMMAND_CODE_TARGET_RAW_FRAMES
+	 */
+	u32 command_code:2;
+
+	/**
+	 * This field is set to true if the remote node should be suspended.
+	 * This bit is only valid for SSP & SMP target devices.
+	 */
+	u32 suspend_node:1;
+
+	/**
+	 * This field is programmed with one of the following command type codes
+	 *
+	 * For SAS requests use the SCU_SSP_TASK_TYPE
+	 *    - SCU_TASK_TYPE_IOREAD
+	 *    - SCU_TASK_TYPE_IOWRITE
+	 *    - SCU_TASK_TYPE_SMP_REQUEST
+	 *    - SCU_TASK_TYPE_RESPONSE
+	 *    - SCU_TASK_TYPE_RAW_FRAME
+	 *    - SCU_TASK_TYPE_PRIMITIVE
+	 *
+	 * For SATA requests use the SCU_SATA_TASK_TYPE
+	 *    - SCU_TASK_TYPE_DMA_IN
+	 *    - SCU_TASK_TYPE_FPDMAQ_READ
+	 *    - SCU_TASK_TYPE_PACKET_DMA_IN
+	 *    - SCU_TASK_TYPE_SATA_RAW_FRAME
+	 *    - SCU_TASK_TYPE_DMA_OUT
+	 *    - SCU_TASK_TYPE_FPDMAQ_WRITE
+	 *    - SCU_TASK_TYPE_PACKET_DMA_OUT
+	 */
+	u32 task_type:4;
+
+	/* OFFSET 0x08 */
+	/**
+	 * This field is reserved and the must be set to 0x00
+	 */
+	u32 link_layer_control:8; /* presently all reserved */
+
+	/**
+	 * This field is set to true when TLR is to be enabled
+	 */
+	u32 ssp_tlr_enable:1;
+
+	/**
+	 * This is field specifies if the SCU DMAs a response frame to host
+	 * memory for good response frames when operating in target mode.
+	 */
+	u32 dma_ssp_target_good_response:1;
+
+	/**
+	 * This field indicates if the SCU should DMA the response frame to
+	 * host memory.
+	 */
+	u32 do_not_dma_ssp_good_response:1;
+
+	/**
+	 * This field is set to true when strict ordering is to be enabled
+	 */
+	u32 strict_ordering:1;
+
+	/**
+	 * This field indicates the type of endianess to be utilized for the
+	 * frame.  command, task, and response frames utilized control_frame
+	 * set to 1.
+	 */
+	u32 control_frame:1;
+
+	/**
+	 * This field is reserved and the driver should set to 0x00
+	 */
+	u32 tl_control_reserved:3;
+
+	/**
+	 * This field is set to true when the SCU hardware task timeout control is to
+	 * be enabled
+	 */
+	u32 timeout_enable:1;
+
+	/**
+	 * This field is reserved and the driver should set it to 0x00
+	 */
+	u32 pts_control_reserved:7;
+
+	/**
+	 * This field should be set to true when block guard is to be enabled
+	 */
+	u32 block_guard_enable:1;
+
+	/**
+	 * This field is reserved and the driver should set to 0x00
+	 */
+	u32 sdma_control_reserved:7;
+
+	/* OFFSET 0x0C */
+	/**
+	 * This field is the address modifier for this io request it should be
+	 * programmed with the virtual function that is making the request.
+	 */
+	u32 address_modifier:16;
+
+	/**
+	 * @todo What we support mirrored SMP response frame?
+	 */
+	u32 mirrored_protocol_engine:3;  /* mirrored protocol Engine Index */
+
+	/**
+	 * If this is a mirrored request the logical port index for the mirrored RNi
+	 * must be programmed.
+	 */
+	u32 mirrored_logical_port:4;  /* mirrored local port index */
+
+	/**
+	 * This field is reserved and the driver must set it to 0x00
+	 */
+	u32 reserved_0C_0:8;
+
+	/**
+	 * This field must be set to true if the mirrored request processing is to be
+	 * enabled.
+	 */
+	u32 mirror_request_enable:1;  /* Mirrored request Enable */
+
+	/* OFFSET 0x10 */
+	/**
+	 * This field is the command iu length in dwords
+	 */
+	u32 ssp_command_iu_length:8;
+
+	/**
+	 * This is the target TLR enable bit it must be set to 0 when creatning the
+	 * task context.
+	 */
+	u32 xfer_ready_tlr_enable:1;
+
+	/**
+	 * This field is reserved and the driver must set it to 0x00
+	 */
+	u32 reserved_10_0:7;
+
+	/**
+	 * This is the maximum burst size that the SCU hardware will send in one
+	 * connection its value is (N x 512) and N must be a multiple of 2.  If the
+	 * value is 0x00 then maximum burst size is disabled.
+	 */
+	u32 ssp_max_burst_size:16;
+
+	/* OFFSET 0x14 */
+	/**
+	 * This filed is set to the number of bytes to be transfered in the request.
+	 */
+	u32 transfer_length_bytes:24; /* In terms of bytes */
+
+	/**
+	 * This field is reserved and the driver should set it to 0x00
+	 */
+	u32 reserved_14_0:8;
+
+	/* OFFSET 0x18-0x2C */
+	/**
+	 * This union provides for the protocol specif part of the SCU Task Context.
+	 */
+	union PROTOCOL_CONTEXT type;
+
+	/* OFFSET 0x30-0x34 */
+	/**
+	 * This field is the upper 32 bits of the 64 bit physical address of the
+	 * command iu buffer
+	 */
+	u32 command_iu_upper;
+
+	/**
+	 * This field is the lower 32 bits of the 64 bit physical address of the
+	 * command iu buffer
+	 */
+	u32 command_iu_lower;
+
+	/* OFFSET 0x38-0x3C */
+	/**
+	 * This field is the upper 32 bits of the 64 bit physical address of the
+	 * response iu buffer
+	 */
+	u32 response_iu_upper;
+
+	/**
+	 * This field is the lower 32 bits of the 64 bit physical address of the
+	 * response iu buffer
+	 */
+	u32 response_iu_lower;
+
+	/* OFFSET 0x40 */
+	/**
+	 * This field is set to the task phase of the SCU hardware. The driver must
+	 * set this to 0x01
+	 */
+	u32 task_phase:8;
+
+	/**
+	 * This field is set to the transport layer task status.  The driver must set
+	 * this to 0x00
+	 */
+	u32 task_status:8;
+
+	/**
+	 * This field is used during initiator write TLR
+	 */
+	u32 previous_extended_tag:4;
+
+	/**
+	 * This field is set the maximum number of retries for a STP non-data FIS
+	 */
+	u32 stp_retry_count:2;
+
+	/**
+	 * This field is reserved and the driver must set it to 0x00
+	 */
+	u32 reserved_40_1:2;
+
+	/**
+	 * This field is used by the SCU TL to determine when to take a snapshot when
+	 * tranmitting read data frames.
+	 *    - 0x00 The entire IO
+	 *    - 0x01 32k
+	 *    - 0x02 64k
+	 *    - 0x04 128k
+	 *    - 0x08 256k
+	 */
+	u32 ssp_tlr_threshold:4;
+
+	/**
+	 * This field is reserved and the driver must set it to 0x00
+	 */
+	u32 reserved_40_2:4;
+
+	/* OFFSET 0x44 */
+	u32 write_data_length; /* read only set to 0 */
+
+	/* OFFSET 0x48-0x58 */
+	struct TRANSPORT_SNAPSHOT snapshot; /* read only set to 0 */
+
+	/* OFFSET 0x5C */
+	u32 block_protection_enable:1;
+	u32 block_size:2;
+	u32 block_protection_function:2;
+	u32 reserved_5C_0:9;
+	u32 active_sgl_element:2;  /* read only set to 0 */
+	u32 sgl_exhausted:1;  /* read only set to 0 */
+	u32 payload_data_transfer_error:4;  /* read only set to 0 */
+	u32 frame_buffer_offset:11; /* read only set to 0 */
+
+	/* OFFSET 0x60-0x7C */
+	/**
+	 * This field is the first SGL element pair found in the TC data structure.
+	 */
+	struct scu_sgl_element_pair sgl_pair_ab;
+	/* OFFSET 0x80-0x9C */
+	/**
+	 * This field is the second SGL element pair found in the TC data structure.
+	 */
+	struct scu_sgl_element_pair sgl_pair_cd;
+
+	/* OFFSET 0xA0-BC */
+	struct scu_sgl_element_pair sgl_snapshot_ac;
+
+	/* OFFSET 0xC0 */
+	u32 active_sgl_element_pair; /* read only set to 0 */
+
+	/* OFFSET 0xC4-0xCC */
+	u32 reserved_C4_CC[3];
+
+	/* OFFSET 0xD0 */
+	u32 intermediate_crc_value:16;
+	u32 initial_crc_seed:16;
+
+	/* OFFSET 0xD4 */
+	u32 application_tag_for_verify:16;
+	u32 application_tag_for_generate:16;
+
+	/* OFFSET 0xD8 */
+	u32 reference_tag_seed_for_verify_function;
+
+	/* OFFSET 0xDC */
+	u32 reserved_DC;
+
+	/* OFFSET 0xE0 */
+	u32 reserved_E0_0:16;
+	u32 application_tag_mask_for_generate:16;
+
+	/* OFFSET 0xE4 */
+	u32 block_protection_control:16;
+	u32 application_tag_mask_for_verify:16;
+
+	/* OFFSET 0xE8 */
+	u32 block_protection_error:8;
+	u32 reserved_E8_0:24;
+
+	/* OFFSET 0xEC */
+	u32 reference_tag_seed_for_verify;
+
+	/* OFFSET 0xF0 */
+	u32 intermediate_crc_valid_snapshot:16;
+	u32 reserved_F0_0:16;
+
+	/* OFFSET 0xF4 */
+	u32 reference_tag_seed_for_verify_function_snapshot;
+
+	/* OFFSET 0xF8 */
+	u32 snapshot_of_reserved_dword_DC_of_tc;
+
+	/* OFFSET 0xFC */
+	u32 reference_tag_seed_for_generate_function_snapshot;
+
+};
+
+#endif /* _SCU_TASK_CONTEXT_H_ */
diff --git a/drivers/scsi/isci/core/scu_viit_data.h b/drivers/scsi/isci/core/scu_viit_data.h
new file mode 100644
index 0000000..c959d91
--- /dev/null
+++ b/drivers/scsi/isci/core/scu_viit_data.h
@@ -0,0 +1,178 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _SCU_VIIT_DATA_HEADER_
+#define _SCU_VIIT_DATA_HEADER_
+
+/**
+ * This file contains the constants and structures for the SCU hardware VIIT
+ *    table entries.
+ *
+ *
+ */
+
+
+#define SCU_VIIT_ENTRY_ID_MASK         (0xC0000000)
+#define SCU_VIIT_ENTRY_ID_SHIFT        (30)
+
+#define SCU_VIIT_ENTRY_FUNCTION_MASK   (0x0FF00000)
+#define SCU_VIIT_ENTRY_FUNCTION_SHIFT  (20)
+
+#define SCU_VIIT_ENTRY_IPPTMODE_MASK   (0x0001F800)
+#define SCU_VIIT_ENTRY_IPPTMODE_SHIFT  (12)
+
+#define SCU_VIIT_ENTRY_LPVIE_MASK      (0x00000F00)
+#define SCU_VIIT_ENTRY_LPVIE_SHIFT     (8)
+
+#define SCU_VIIT_ENTRY_STATUS_MASK     (0x000000FF)
+#define SCU_VIIT_ENTRY_STATUS_SHIFT    (0)
+
+#define SCU_VIIT_ENTRY_ID_INVALID   (0 << SCU_VIIT_ENTRY_ID_SHIFT)
+#define SCU_VIIT_ENTRY_ID_VIIT      (1 << SCU_VIIT_ENTRY_ID_SHIFT)
+#define SCU_VIIT_ENTRY_ID_IIT       (2 << SCU_VIIT_ENTRY_ID_SHIFT)
+#define SCU_VIIT_ENTRY_ID_VIRT_EXP  (3 << SCU_VIIT_ENTRY_ID_SHIFT)
+
+#define SCU_VIIT_IPPT_SSP_INITIATOR (0x01 << SCU_VIIT_ENTRY_IPPTMODE_SHIFT)
+#define SCU_VIIT_IPPT_SMP_INITIATOR (0x02 << SCU_VIIT_ENTRY_IPPTMODE_SHIFT)
+#define SCU_VIIT_IPPT_STP_INITIATOR (0x04 << SCU_VIIT_ENTRY_IPPTMODE_SHIFT)
+#define SCU_VIIT_IPPT_INITIATOR	    \
+	(\
+		SCU_VIIT_IPPT_SSP_INITIATOR  \
+		| SCU_VIIT_IPPT_SMP_INITIATOR  \
+		| SCU_VIIT_IPPT_STP_INITIATOR  \
+	)
+
+#define SCU_VIIT_STATUS_RNC_VALID      (0x01 << SCU_VIIT_ENTRY_STATUS_SHIFT)
+#define SCU_VIIT_STATUS_ADDRESS_VALID  (0x02 << SCU_VIIT_ENTRY_STATUS_SHIFT)
+#define SCU_VIIT_STATUS_RNI_VALID      (0x04 << SCU_VIIT_ENTRY_STATUS_SHIFT)
+#define SCU_VIIT_STATUS_ALL_VALID      \
+	(\
+		SCU_VIIT_STATUS_RNC_VALID	\
+		| SCU_VIIT_STATUS_ADDRESS_VALID	  \
+		| SCU_VIIT_STATUS_RNI_VALID	  \
+	)
+
+#define SCU_VIIT_IPPT_SMP_TARGET    (0x10 << SCU_VIIT_ENTRY_IPPTMODE_SHIFT)
+
+/**
+ * struct scu_viit_entry - This is the SCU Virtual Initiator Table Entry
+ *
+ *
+ */
+struct scu_viit_entry {
+	/**
+	 * This must be encoded as to the type of initiator that is being constructed
+	 * for this port.
+	 */
+	u32 status;
+
+	/**
+	 * Virtual initiator high SAS Address
+	 */
+	u32 initiator_sas_address_hi;
+
+	/**
+	 * Virtual initiator low SAS Address
+	 */
+	u32 initiator_sas_address_lo;
+
+	/**
+	 * This must be 0
+	 */
+	u32 reserved;
+
+};
+
+
+/* IIT Status Defines */
+#define SCU_IIT_ENTRY_ID_MASK                (0xC0000000)
+#define SCU_IIT_ENTRY_ID_SHIFT               (30)
+
+#define SCU_IIT_ENTRY_STATUS_UPDATE_MASK     (0x20000000)
+#define SCU_IIT_ENTRY_STATUS_UPDATE_SHIFT    (29)
+
+#define SCU_IIT_ENTRY_LPI_MASK               (0x00000F00)
+#define SCU_IIT_ENTRY_LPI_SHIFT              (8)
+
+#define SCU_IIT_ENTRY_STATUS_MASK            (0x000000FF)
+#define SCU_IIT_ENTRY_STATUS_SHIFT           (0)
+
+/* IIT Remote Initiator Defines */
+#define SCU_IIT_ENTRY_REMOTE_TAG_MASK  (0x0000FFFF)
+#define SCU_IIT_ENTRY_REMOTE_TAG_SHIFT (0)
+
+#define SCU_IIT_ENTRY_REMOTE_RNC_MASK  (0x0FFF0000)
+#define SCU_IIT_ENTRY_REMOTE_RNC_SHIFT (16)
+
+#define SCU_IIT_ENTRY_ID_INVALID   (0 << SCU_IIT_ENTRY_ID_SHIFT)
+#define SCU_IIT_ENTRY_ID_VIIT      (1 << SCU_IIT_ENTRY_ID_SHIFT)
+#define SCU_IIT_ENTRY_ID_IIT       (2 << SCU_IIT_ENTRY_ID_SHIFT)
+#define SCU_IIT_ENTRY_ID_VIRT_EXP  (3 << SCU_IIT_ENTRY_ID_SHIFT)
+
+/**
+ * struct scu_iit_entry - This will be implemented later when we support
+ *    virtual functions
+ *
+ *
+ */
+struct scu_iit_entry {
+	u32 status;
+	u32 remote_initiator_sas_address_hi;
+	u32 remote_initiator_sas_address_lo;
+	u32 remote_initiator;
+
+};
+
+#endif /* _SCU_VIIT_DATA_HEADER_ */

